//
//  TotalViewModel.swift
//  TrabalhoFinal
//
//  Created by Valmir Junior on 27/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import Foundation

protocol TotalViewModelDelegate: AnyObject {
    func onSuccess()
    func onError(with message: String)
}

final class TotalViewModel {
    private var repository: ProductRepositoryProtocol
    private var exchangeRate: Decimal? = 5.0
    private var percIOF:Decimal? = 6.38
    private let ud = UserDefaults.standard
    private var totalUSD: Decimal = 0.0
    private var totalBRL: Decimal = 0.0
    private var products: [Product] = []
    
    weak var delegate: TotalViewModelDelegate?
    
    var totalUSDValue = ""
    var totalBRLValue = ""
    
    init(_ repository: ProductRepositoryProtocol = ProductRepository()) {
        self.repository = repository
        self.repository.delegate = self
    }
    
    //MARK: - Methods
    func loadData() {
        //Carrega dolar e IOF do userDefaults
        exchangeRate = NSDecimalNumber(string: ud.string(forKey: UserDefaultKeys.dolar.rawValue) ?? "0.0").decimalValue
        percIOF = NSDecimalNumber(string: ud.string(forKey: UserDefaultKeys.iof.rawValue) ?? "0.0").decimalValue
        
        repository.loadProducts()
    }
    
    private func calculate() {
        //Zera as variaveis de total
        totalUSD = 0.0
        totalBRL = 0.0
        
        //Verifica se existem produtos, caso contrario exibe 0 para os totais
        //Caso existam produtos
        if products.count > 0 {
            
            //Varre todos os produtos existentes
            for product in products {
                
                //Busca o valor bruto do produto
                let decimalValueOfProduct = product.value?.decimalValue
                
                //Soma o valor bruto em dolar ao total USD
                totalUSD = totalUSD + decimalValueOfProduct!
                
                //Inicia variavel da taxa do estado com 6% por padrão
                var taxFromState: Decimal? = 6.0
                
                //Caso exista uma taxa de estado no produto, substitui a default 6.0
                if (product.state?.tax?.decimalValue != nil) {
                    taxFromState = product.state?.tax?.decimalValue
                }
                
                //Calcula o total em BRL
                //totalProductBRL = ValorProduto * ((TaxaEstado/100) + 1) * CotacaoDolar
                var totalProductBRL = decimalValueOfProduct! * ( (taxFromState!/100) + 1 ) * exchangeRate!
                
                //Verifica se produto foi pago com cartão
                if product.isCredit {
                    //Usou cartão de credito, incluir IOF
                    totalProductBRL = totalProductBRL * ( (percIOF!/100) + 1 )
                }
                
                //Soma o valor calculado em BRL do produto ao total BRL
                totalBRL = totalBRL + totalProductBRL
            }
            
        }
        
        //Exibe totais na tela
        totalUSDValue = String(format: "%.2f", Double(truncating:totalUSD as NSNumber))
        totalBRLValue = String(format: "%.2f", Double(truncating:totalBRL as NSNumber))
    }
}

//MARK: - Product repository delegate
extension TotalViewModel: ProductRepositoryDelegate {
    func productRepository(didUpdateError: Error) {
        delegate?.onError(with: didUpdateError.localizedDescription)
    }
    
    func productRepository(didUpdateProducts: [Product]) {
        products = didUpdateProducts
        calculate()
        delegate?.onSuccess()
    }
}
