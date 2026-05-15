@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR2 B2B CDS1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGSTR2_RCM_CDS1
  as select from    I_JournalEntry            as A
    left outer join I_OperationalAcctgDocItem as B    on(
         B.AccountingDocument = A.AccountingDocument
         and B.CompanyCode    = A.CompanyCode
         and B.FiscalYear     = A.FiscalYear
       )
 
    left outer join I_SupplierInvoiceAPI01      as C    on(
         A.OriginalReferenceDocument = concat(
           C.SupplierInvoice, C.FiscalYear
         )
         and C.CompanyCode           = A.CompanyCode
         and C.FiscalYear            = A.FiscalYear
       )
    left outer join C_SupplierInvoiceItemDEX  as D    on(
         D.SupplierInvoice = C.SupplierInvoice
         and D.CompanyCode = C.CompanyCode
         and D.FiscalYear  = C.FiscalYear
       )
    left outer join I_OperationalAcctgDocItem as K    on(
         K.AccountingDocument       = A.AccountingDocument
         and K.CompanyCode          = A.CompanyCode
         and K.FiscalYear           = A.FiscalYear
         and K.FinancialAccountType = 'K'
       )
    left outer join I_Supplier                as K2   on(
        K2.Supplier = K.Supplier
      )

    left outer join I_OperationalAcctgDocItem as CGST on(
      CGST.AccountingDocument         = A.AccountingDocument
      and CGST.CompanyCode            = A.CompanyCode
      and CGST.FiscalYear             = A.FiscalYear
      and CGST.TaxItemAcctgDocItemRef = B.TaxItemAcctgDocItemRef
      and CGST.TaxCode                = B.TaxCode
      and CGST.GLAccount              = '1601001040'
    )
    left outer join I_OperationalAcctgDocItem as IGST on(
      IGST.AccountingDocument         = A.AccountingDocument
      and IGST.CompanyCode            = A.CompanyCode
      and IGST.FiscalYear             = A.FiscalYear
      and IGST.TaxItemAcctgDocItemRef = B.TaxItemAcctgDocItemRef
      and IGST.TaxCode                = B.TaxCode
      and IGST.GLAccount              = '1601001060'
    )

    left outer join ZTAXCODE_SUMMARY          as CT   on(
        CT.taxcode         = B.TaxCode
        and CGST.GLAccount = '1601001040'
      )
    left outer join ZTAXCODE_SUMMARY          as IT   on(
        IT.taxcode         = B.TaxCode
        and IGST.GLAccount = '1601001060'
      )

    left outer join I_ProductDescription      as p    on(
         p.Product      = B.Product
         and p.Language = 'E'
       )
       
       
       
       
       left outer join I_OperationalAcctgDocItem as CGST1 on(
      CGST1.AccountingDocument         = A.AccountingDocument
      and CGST1.CompanyCode            = A.CompanyCode
      and CGST1.FiscalYear             = A.FiscalYear
      and CGST1.TaxItemAcctgDocItemRef = B.TaxItemAcctgDocItemRef
      and CGST1.TaxCode                = B.TaxCode
      and CGST1.TransactionTypeDetermination <> 'WIT' 
      and CGST1.FinancialAccountType = 'S' 
      and CGST1.AccountingDocumentItemType <> 'T'
      and CGST1.TaxItemAcctgDocItemRef <> '000000' )
      
       
       left outer join ZWIT_AMNT as WIT on 
       (WIT.AccountingDocument = B.AccountingDocument and
        WIT.CompanyCode = B.CompanyCode and
        WIT.FiscalYear = B.FiscalYear)
      


{

  B.CompanyCode,
  B.AccountingDocument,
  B.TaxItemAcctgDocItemRef,
  C.SupplierInvoice,
  B.FiscalYear,
  B.DocumentDate,
  B.PostingDate,
//  gl.GLAccount,
  B.TaxCode,
  //  B.Product ,
  B.Plant,
  A.DocumentReferenceID,
  A.FiscalPeriod,
  K.Supplier,
  K2.SupplierName,
  B.AccountingDocumentType,
  B.BusinessPlace,
  K2.TaxNumber3                                                                   as SUP_GST,
  K2.Region                                                                       as IN_GSTPlaceOfSupply,

  //  B.IN_GSTPlaceOfSupply ,

  B.BaseUnit,
  B.TransactionCurrency,
  B.CompanyCodeCurrency,

  @Semantics.quantity.unitOfMeasure: 'BaseUnit'
  B.Quantity,

case
    when B.TaxItemAcctgDocItemRef = '000001'
//         then cast(CGST1.AmountInCompanyCodeCurrency as abap.dec(20,2)) 
      then coalesce(cast(CGST1.AmountInCompanyCodeCurrency as abap.dec(20,2)),0)  + coalesce(WIT.WIT_AMNT, 0)
    else
         coalesce(cast(CGST1.AmountInCompanyCodeCurrency as abap.dec(20,2)),0)
end as INVOICE_AMT, 


  WIT.WIT_AMNT as WIT_AMNT,

//  case when CGST1.TransactionTypeDetermination = '' or CGST.TransactionTypeDetermination is initial
//  then 
  cast(CGST1.AmountInCompanyCodeCurrency as abap.dec( 20, 2 ) )    as AmountInCompanyCodeCurrency,
  
  
  
  cast(CGST.AmountInCompanyCodeCurrency as abap.dec( 20, 2 ) )                    as Cgst_amt,
  cast(CGST.AmountInCompanyCodeCurrency as abap.dec( 20, 2 ) )                    as sgst_amt,
  cast(IGST.AmountInCompanyCodeCurrency as abap.dec( 20, 2 ) )                    as igst_amt,

  CT.gstrate                                                                      as cgst_rate,
  CT.gstrate                                                                      as sgst_rate,
  IT.gstrate                                                                      as igst_rate,

  cast( 'RCM REGISTER'  as abap.char(20)  )                                              as REPORT,

   p.ProductDescription ,
   B.Product ,
   
  D.IsSubsequentDebitCredit,
  C.IsInvoice,
  C.ReverseDocument,
  C.SupplierInvoiceStatus,
  '' as SupplierFullName,
  '' as IN_HSNOrSACCode






}
where
  (
       A.AccountingDocumentType         =       'KR'
    or A.AccountingDocumentType         =       'KG'
    or A.AccountingDocumentType         =       'RE'
    or A.AccountingDocumentType         =       'KN'
    or A.AccountingDocumentType         =       'ZA'
    or A.AccountingDocumentType         =       'Y1'
  )

  and  B.TaxItemAcctgDocItemRef         <>      '000000' 
  
  
  and  B.GLAccount                      <>      '1601001040'
  and  B.GLAccount                      <>      '1601001050'
  and  B.GLAccount                      <>      '1601001060'
  and  B.GLAccount                      <>      '2401001210'
  and  B.GLAccount                      <>      '2401001220'
  and  B.GLAccount                      <>      '2401001230'
  and  A.IsReversal                     <>      'X'
  and  A.IsReversed                     <>      'X'
  
  and B.TaxCode                        between 'R1' and 'R8' 
  
  
  and(
       CGST.AmountInCompanyCodeCurrency is not null
    or IGST.AmountInCompanyCodeCurrency is not null
  )

  group by
  
      B.CompanyCode,                   
      B.AccountingDocument,            
      B.TaxItemAcctgDocItemRef,        
      C.SupplierInvoice,               
      B.FiscalYear,                    
      B.DocumentDate,                  
      B.PostingDate,                                 
      B.TaxCode,                       
      //  B.Product ,                  
      B.Plant,                         
      A.DocumentReferenceID,           
      A.FiscalPeriod,                  
      K.Supplier,                      
      K2.SupplierName,                 
      B.AccountingDocumentType,        
      B.BusinessPlace,                 
      K2.TaxNumber3 ,                   
      K2.Region,
    B.BaseUnit,
    B.TransactionCurrency,
    B.CompanyCodeCurrency,
    B.Quantity,
//    CGST1.AmountInCompanyCodeCurrency,
    CGST.AmountInCompanyCodeCurrency,
    IGST.AmountInCompanyCodeCurrency,
    CT.gstrate,
    IT.gstrate,
    p.ProductDescription,
    B.Product,
    C.IsInvoice,
    D.IsSubsequentDebitCredit,
    C.SupplierInvoiceStatus,
    C.ReverseDocument,
//    C.YY1_Transporter_MIH,
//    C.YY1_GRRRNo_MIH,
//    C.YY1_BillofEntryDate_MIH,
//    C.YY1_BillofEntryNo_MIH,
//    C.YY1_BillofEntryValue_MIHC,
//    C.YY1_BillofEntryValue_MIH,
//    C.YY1_EWAYBILLNO_MIH,
//    C.YY1_GSTIN_MIH,
//    C.YY1_Import_MIH,
//    C.YY1_PortCode_MIH,
//    C.YY1_VehicleNo_MIH,
    CGST1.AmountInCompanyCodeCurrency  ,
    WIT.WIT_AMNT                      
//                                       
