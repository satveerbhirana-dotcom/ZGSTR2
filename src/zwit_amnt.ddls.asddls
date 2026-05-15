@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'WIT AMOUNT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZWIT_AMNT as select from I_OperationalAcctgDocItem as A


{  key A.AccountingDocument,
//       A.AccountingDocumentItem,
       A.FiscalYear,
       A.CompanyCode,
       coalesce(cast(A.AmountInCompanyCodeCurrency as abap.dec(20,2)), 0) as WIT_AMNT,
       A.TransactionTypeDetermination as WIT
    
}

where A.TransactionTypeDetermination = 'WIT' and
      A.TaxItemAcctgDocItemRef = '000000'
