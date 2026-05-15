@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RCM INVOICE AMOUNT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRCM_INVOICE_AMT as select distinct from    I_JournalEntry  as A

 left outer join I_OperationalAcctgDocItem as B on (
     B.AccountingDocument = A.AccountingDocument and
     B.CompanyCode    = A.CompanyCode and
     B.FiscalYear     = A.FiscalYear )

 left outer join I_OperationalAcctgDocItem as CGST1 on(
      CGST1.AccountingDocument         = A.AccountingDocument
      and CGST1.CompanyCode            = A.CompanyCode
      and CGST1.FiscalYear             = A.FiscalYear
      and CGST1.TaxItemAcctgDocItemRef = B.TaxItemAcctgDocItemRef
      and CGST1.TaxCode                = B.TaxCode
      and CGST1.TransactionTypeDetermination = '' 
      and CGST1.TaxItemAcctgDocItemRef <> '000000' )

 left outer join ZWIT_AMNT as WIT on 
       (WIT.AccountingDocument = B.AccountingDocument and
        WIT.CompanyCode = B.CompanyCode and
        WIT.FiscalYear = B.FiscalYear) 
        
        
 left outer join ZWIT as WIT1 on 
       (WIT1.AccountingDocument = B.AccountingDocument and
       WIT1.AccountingDocumentItem = B.AccountingDocumentItem and
        WIT1.CompanyCode = B.CompanyCode and
        WIT1.FiscalYear = B.FiscalYear)        

{ 
  key B.AccountingDocument,
      B.AccountingDocumentItem,
      B.CompanyCode,
      B.FiscalYear,
      
      cast(CGST1.AmountInCompanyCodeCurrency as abap.dec( 20, 2 )) as AmountInCompanyCodeCurrency,
      WIT.WIT_AMNT,
      
    case
    when WIT1.TransactionTypeDetermination = 'WIT' 
    then cast(CGST1.AmountInCompanyCodeCurrency as abap.dec(20,2)) - max(WIT.WIT_AMNT)
    else
    WIT.WIT_AMNT end
 as INVOICE_AMT,
 
 WIT.WIT
   



    
}



where
  (
       A.AccountingDocumentType         =       'KR'
    or A.AccountingDocumentType         =       'KG'
    or A.AccountingDocumentType         =       'RE'
    or A.AccountingDocumentType         =       'VC'
    or A.AccountingDocumentType         =       'ZA'
    or A.AccountingDocumentType         =       'Y1'
  )

  and  B.TaxItemAcctgDocItemRef         <>      '000000' 
  
  
  and  B.GLAccount                      <>      '0002701004'
  and  B.GLAccount                      <>      '0002701005'
  and  B.GLAccount                      <>      '0002701006'
  and  B.GLAccount                      <>      '0001501007'
  and  B.GLAccount                      <>      '0001501008'
  and  B.GLAccount                      <>      '0001501009'
  and  A.IsReversal                     <>      'X'
  and  A.IsReversed                     <>      'X'
  
  and B.TaxCode                        between 'R1' and 'R8' 
  
  
 group by
 
 B.AccountingDocument,    
 B.AccountingDocumentItem,
 B.CompanyCode,           
 B.FiscalYear,
    CGST1.AmountInCompanyCodeCurrency,
    WIT.WIT_AMNT,
    WIT.WIT,
    B.TransactionTypeDetermination,
    WIT1.TransactionTypeDetermination           
 