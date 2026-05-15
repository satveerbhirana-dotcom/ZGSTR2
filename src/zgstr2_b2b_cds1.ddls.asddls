@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR2 B2B CDS1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGSTR2_B2B_CDS1
  as select distinct from I_JournalEntry            as A
    left outer join       I_OperationalAcctgDocItem as B      on(
           B.AccountingDocument = A.AccountingDocument
           and B.CompanyCode    = A.CompanyCode
           and B.FiscalYear     = A.FiscalYear
         )

    left outer join       I_SupplierInvoiceAPI01    as C      on(
           A.OriginalReferenceDocument = concat(
             C.SupplierInvoice, C.FiscalYear
           )
           and C.CompanyCode           = A.CompanyCode
           and C.FiscalYear            = A.FiscalYear
         )
    left outer join       C_SupplierInvoiceItemDEX  as D      on(
           D.SupplierInvoice = C.SupplierInvoice
           and D.CompanyCode = C.CompanyCode
           and D.FiscalYear  = C.FiscalYear
         )

    left outer join       I_OperationalAcctgDocItem as K      on(
           K.AccountingDocument       = A.AccountingDocument
           and K.CompanyCode          = A.CompanyCode
           and K.FiscalYear           = A.FiscalYear
           and K.FinancialAccountType = 'K'
         )
    left outer join       I_Supplier                as K2     on(
          K2.Supplier = K.Supplier
        )

    left outer join       I_OperationalAcctgDocItem as CGST   on(
        CGST.AccountingDocument         = A.AccountingDocument
        and CGST.CompanyCode            = A.CompanyCode
        and CGST.FiscalYear             = A.FiscalYear
        and CGST.TaxItemAcctgDocItemRef = B.TaxItemAcctgDocItemRef
        and CGST.TaxCode                = B.TaxCode
        and CGST.GLAccount              = '1601001010' 
      )
    left outer join       I_OperationalAcctgDocItem as IGST   on(
        IGST.AccountingDocument         = A.AccountingDocument
        and IGST.CompanyCode            = A.CompanyCode
        and IGST.FiscalYear             = A.FiscalYear
        and IGST.TaxItemAcctgDocItemRef = B.TaxItemAcctgDocItemRef
        and IGST.TaxCode                = B.TaxCode
        and IGST.GLAccount              = '1601001030'
      )
    left outer join       I_OperationalAcctgDocItem as IGST_I on(
      IGST_I.AccountingDocument         = A.AccountingDocument
      and IGST_I.CompanyCode            = A.CompanyCode
      and IGST_I.FiscalYear             = A.FiscalYear
      and IGST_I.TaxItemAcctgDocItemRef = B.TaxItemAcctgDocItemRef             
      and IGST_I.GLAccount              = '1601001030'
    )
    
    
    
        left outer join       I_OperationalAcctgDocItem as MANUALSGST on(
      MANUALSGST.AccountingDocument         = A.AccountingDocument
      and MANUALSGST.CompanyCode            = A.CompanyCode
      and MANUALSGST.FiscalYear             = A.FiscalYear
      and ( MANUALSGST.GLAccount  = '1601001010'  )         
      and MANUALSGST.TaxItemAcctgDocItemRef <>  B.TaxItemAcctgDocItemRef 
      and MANUALSGST.AccountingDocumentItemType = ''
      
    )
    
      left outer join       I_OperationalAcctgDocItem as MANUALIGST on(
      MANUALIGST.AccountingDocument         = A.AccountingDocument
      and MANUALIGST.CompanyCode            = A.CompanyCode
      and MANUALIGST.FiscalYear             = A.FiscalYear
      and ( MANUALIGST.GLAccount  = '1601001030'   )
      and MANUALIGST.TaxItemAcctgDocItemRef <>  B.TaxItemAcctgDocItemRef 
      and MANUALIGST.AccountingDocumentItemType = ''
      
    )

    left outer join       ZTAXCODE_SUMMARY          as CT     on(
          CT.taxcode         = B.TaxCode
          and ( CGST.GLAccount = '1601001010' or MANUALSGST.GLAccount  = '1601001010' )
        )
    left outer join       ZTAXCODE_SUMMARY          as IT     on(
          IT.taxcode         = B.TaxCode
          and ( IGST.GLAccount = '1601001030' or MANUALIGST.GLAccount  = '1601001030'  )
        )
    left outer join       ZTAXCODE_SUMMARY          as IT_I   on(
        IT_I.taxcode         = B.TaxCode
        and IGST_I.GLAccount = '1601001030'
      )

    left outer join       I_ProductDescription      as p      on(
           p.Product      = B.Product
           and p.Language = 'E'
         )
    left outer join       I_GLAccountStdVH          as gla    on(
         gla.GLAccount       = B.GLAccount
         and gla.CompanyCode = A.CompanyCode
       )




{

  B.CompanyCode,
  B.AccountingDocument,
  B.TaxItemAcctgDocItemRef,
  C.SupplierInvoice,
  B.FiscalYear,
  B.DocumentDate,
  B.PostingDate,
  B.TaxCode,
  B.Plant,
  A.DocumentReferenceID,
  A.FiscalPeriod,
  K.Supplier,
  K2.SupplierName,
  B.AccountingDocumentType,
  B.BusinessPlace,
  K2.TaxNumber3                                                                                        as SUP_GST,
  K2.Region                                                                                            as IN_GSTPlaceOfSupply,

  B.BaseUnit,
  B.TransactionCurrency,
  B.CompanyCodeCurrency,

  @Semantics.quantity.unitOfMeasure: 'BaseUnit'
  cast(B.Quantity as abap.dec( 20, 3 ) )                                                               as Quantity,
  B.GLAccount,
  cast(B.AmountInCompanyCodeCurrency as abap.dec( 20 , 2 ) )                                           as AmountInCompanyCodeCurrency,

  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  cast( coalesce( cast(CGST.TaxBaseAmountInCoCodeCrcy as abap.dec( 20 , 2 ) ) , 0 )
  + coalesce( cast(IGST.TaxBaseAmountInCoCodeCrcy as abap.dec( 20 , 2 ) ), 0 ) as abap.dec( 20 , 2 ) ) as TAXABLE_AMT,

  case when MANUALSGST.AmountInCompanyCodeCurrency is not null then cast(MANUALSGST.AmountInCompanyCodeCurrency as abap.dec( 20 , 2 ) )
  else cast(CGST.AmountInCompanyCodeCurrency as abap.dec( 20 , 2 ) )   end        as Cgst_amt,
  
  case when MANUALSGST.AmountInCompanyCodeCurrency is not null then cast(MANUALSGST.AmountInCompanyCodeCurrency as abap.dec( 20 , 2 ) )
  else cast(CGST.AmountInCompanyCodeCurrency as abap.dec( 20 , 2 ) )   end        as sgst_amt,  
  
  case when IGST.AmountInCompanyCodeCurrency is null and CGST.AmountInCompanyCodeCurrency is null
  then case when MANUALIGST.AmountInCompanyCodeCurrency is not null then cast(MANUALIGST.AmountInCompanyCodeCurrency as abap.dec( 20 , 2 ) )
  else cast(IGST_I.AmountInCompanyCodeCurrency as abap.dec( 20 , 2 ) ) end
  else case when MANUALIGST.AmountInCompanyCodeCurrency is not null then cast(MANUALIGST.AmountInCompanyCodeCurrency as abap.dec( 20 , 2 ) )
  else cast(IGST.AmountInCompanyCodeCurrency as abap.dec( 20 , 2 ) ) end end as igst_amt ,
  
  
  cast(IGST_I.AmountInCompanyCodeCurrency as abap.dec( 20 , 2 ) )                                      as igst_amt_I,

  CT.gstrate                                                                                           as cgst_rate,
  CT.gstrate                                                                                           as sgst_rate,
  IT.gstrate                                                                                           as igst_rate,
  IT_I.gstrate                                                                                         as igst_rate_I,

  cast( 'B2B'  as abap.char(20)  )                                                                     as REPORT,

  p.ProductDescription                                                                                 as p1,
  p.ProductDescription                                                                                 as ProductDescription,
  B.Product,

  C.IsInvoice,
  C.ReverseDocument,
  C.SupplierInvoiceStatus,
  D.IsSubsequentDebitCredit,
  A.IsReversal,
  A.IsReversed


}
where
  (
       A.AccountingDocumentType =    'KR'
    or A.AccountingDocumentType =    'RE'
  )
  and  B.GLAccount              <>   '1601001010'
  and  B.GLAccount              <>   '1601001020'
  and  B.GLAccount              <>   '1601001030'

  and(

   ( B.TaxCode like 'V%' and B.TaxCode <> 'V0' )  
    or B.TaxCode                like 'I%'
  )
  and  B.TaxItemAcctgDocItemRef <>   '000000'
  and  gla.GLAccountType        <>   'N'
