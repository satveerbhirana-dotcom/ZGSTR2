@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR2 REPORT'
@Metadata.ignorePropagatedAnnotations: true
@UI: { headerInfo: { typeName: 'Report', typeNamePlural: 'GSTR2 Report'  } }
define root view entity ZGSTR2_UNION_CDS
  as select distinct from ZGSTR2_B2B_CDS2 as A
{
       @UI.lineItem       : [{position: 10}]
      @UI.selectionField : [{position: 10}]
      @EndUserText.label: 'Company Code'
  key A.CompanyCode,
     @UI.lineItem      : [{ position: 20 }]
      @UI.selectionField : [{position: 30}]
      @Consumption.valueHelpDefinition: [ { entity : { name: 'ZACCDOC_F4', element : 'accdoc' } }]
      @EndUserText.label: 'Accounting Document'
  key A.AccountingDocument,
      @UI.lineItem      : [{ position: 30 }]
      @UI.selectionField : [{position: 20}]
      @EndUserText.label: 'Fiscal Year'
  key A.FiscalYear,
  @UI.lineItem : [{position: 310}]
  @EndUserText.label: 'Item'
  key A.doc_item,
  @UI.selectionField : [{position: 40}]
  @UI.lineItem      : [{ position: 40 }]
  @EndUserText.label: 'Supplier Invoice'
  key A.SupplierInvoice,
  @UI.lineItem      : [{ position: 170 }]
  @EndUserText.label: 'Product Description'
  key A.ProductDescription,
  @UI.lineItem      : [{ position: 280 }]
  @EndUserText.label: 'HSN Code'
  key A.ConsumptionTaxCtrlCode,
  @UI.lineItem      : [{ position: 50 }]
  @EndUserText.label: 'Document Date'
  key A.DocumentDate,
  @UI.lineItem      : [{ position: 60 }]
  @EndUserText.label: 'Posting Date'
  key A.PostingDate,
  @UI.lineItem      : [{ position: 150 }]
  @EndUserText.label: 'Tax Code'
  key A.TaxCode,
  @UI.lineItem      : [{ position: 160 }]
  @EndUserText.label: 'Product'
  key A.Product,
  @UI.lineItem : [{position: 141}]
  @EndUserText.label: 'Plant'
  key A.Plant, 
  @UI.lineItem : [{position: 300}]
  @EndUserText.label: 'Fiscal Period'
  key A.FiscalPeriod,
  @UI.lineItem      : [{ position: 100 }]
  @EndUserText.label: 'Supplier'
  key A.Supplier,
  @UI.lineItem      : [{ position: 110 }]
  @EndUserText.label: 'Supplier Name'
  key A.SupplierName,
  @UI.lineItem      : [{ position: 90 }]
  @EndUserText.label: 'Accounting Document Type'
  key A.AccountingDocumentType,
  @UI.selectionField : [{position: 50}]
  @UI.lineItem      : [{ position: 140 }]
  @EndUserText.label: 'Business Place'
  key A.BusinessPlace,
  @UI.lineItem      : [{ position: 80 }]
  @EndUserText.label: 'Document Reference ID'
  key A.DocumentReferenceID,
  @UI.lineItem      : [{ position: 130 }]
  @EndUserText.label: 'Region'
  key A.IN_GSTPlaceOfSupply,
  @UI.lineItem      : [{ position: 120 }]
  @EndUserText.label: 'GSTIN'
  key A.SUP_GST,
  @UI.lineItem      : [{ position: 190 }]
  @EndUserText.label: 'Base Unit'
  key A.BaseUnit,
  @UI.lineItem      : [{ position: 70 }]
  @EndUserText.label: 'TransactionCurrency'
  key A.TransactionCurrency,
  @EndUserText.label: 'CompanyCodeCurrency'
  key A.CompanyCodeCurrency,
     @DefaultAggregation: #SUM
     @UI.lineItem      : [{ position: 200 }]
     @EndUserText.label: 'Net Amount'
  key A.AmountInCompanyCodeCurrency,
     @DefaultAggregation: #SUM
     @UI.lineItem      : [{ position: 180 }]
     @EndUserText.label: 'Quantity'
  key A.Quantity,
     @UI.hidden: true
     @DefaultAggregation: #SUM
     @EndUserText.label: 'Taxable Amount'
  key A.TAXABLE_AMT,
     @DefaultAggregation: #SUM
     @UI.lineItem      : [{ position: 210 }]
     @EndUserText.label: 'CGST Amount'
  key A.Cgst_amt,
     @DefaultAggregation: #SUM
     @UI.lineItem      : [{ position: 230 }]
     @EndUserText.label: 'SGST Amount'
  key A.sgst_amt,
     @DefaultAggregation: #SUM
     @UI.lineItem      : [{ position: 250 }]
     @EndUserText.label: 'IGST Amount'
  key A.igst_amt,
  @UI.lineItem      : [{ position: 220 }]
  @EndUserText.label: 'CGST Rate'
  key A.cgst_rate,
  @UI.lineItem      : [{ position: 240 }]
  @EndUserText.label: 'SGST Rate'
  key A.sgst_rate,
  @UI.lineItem      : [{ position: 260 }]
  @EndUserText.label: 'IGST Rate'
  key A.igst_rate,
  @UI.lineItem      : [{ position: 270 }]
     @DefaultAggregation: #SUM
     @EndUserText.label: 'Invoice Amount'
  key A.INVOICE_AMT,
  
      @UI.lineItem             : [{ position: 1000 }]
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.mandatory: true
      @Consumption.defaultValue: 'B2B'
      @EndUserText.label       : 'Report'
      @Consumption.valueHelpDefinition: [ { entity : { name: 'ZGSTR2_F4', element : 'subrep_type' } }]
      @UI.selectionField : [{position: 60}]
      A.REPORT,
    '' as  SupplierFullName,
    '' as  IN_HSNOrSACCode

}


union select distinct from ZGSTR2_CDNR_CDS2 as B

{
  key B.CompanyCode,
  key B.AccountingDocument,
  key B.FiscalYear,
  key B.doc_item,
  key B.SupplierInvoice,
  key B.ProductDescription,
  key B.ConsumptionTaxCtrlCode,
  key B.DocumentDate,
  key B.PostingDate,
  key B.TaxCode,
  key B.Product,
  key B.Plant,
  key B.FiscalPeriod,
  key B.Supplier,
  key B.SupplierName,
  key B.AccountingDocumentType,
  key B.BusinessPlace,
  key B.DocumentReferenceID,
  key B.IN_GSTPlaceOfSupply,
  key B.SUP_GST,
  key B.BaseUnit,
  key B.TransactionCurrency,
  key B.CompanyCodeCurrency,
  key B.AmountInCompanyCodeCurrency,
  key B.Quantity,
  key B.TAXABLE_AMT,
  key B.Cgst_amt,
  key B.sgst_amt,
  key B.igst_amt,
  key B.cgst_rate,
  key B.sgst_rate,
  key B.igst_rate,
  key B.INVOICE_AMT,
      B.REPORT,
     '' as SupplierFullName,
    '' as  IN_HSNOrSACCode
//      B.YY1_Transporter_MIH,
//      B.YY1_GRRRNo_MIH,
//      B.YY1_BillofEntryDate_MIH,
//      B.YY1_BillofEntryNo_MIH,
//      B.YY1_BillofEntryValue_MIHC,
//      B.YY1_BillofEntryValue_MIH,
//      B.YY1_EWAYBILLNO_MIH,
//      B.YY1_GSTIN_MIH,
//      B.YY1_Import_MIH,
//      B.YY1_PortCode_MIH,
//      B.YY1_VehicleNo_MIH

}

union select distinct from ZGSTR2_RCM_CDS2 as C

{
  key C.CompanyCode,
  key C.AccountingDocument,
  key C.FiscalYear,
  key C.doc_item,
  key C.SupplierInvoice,
  key C.ProductDescription,
  key C.ConsumptionTaxCtrlCode,
  key C.DocumentDate,
  key C.PostingDate,
  key C.TaxCode,
  key C.Product,
  key C.Plant,
  key C.FiscalPeriod,
  key C.Supplier,
  key C.SupplierName,
  key C.AccountingDocumentType,
  key C.BusinessPlace,
  key C.DocumentReferenceID,
  key C.IN_GSTPlaceOfSupply,
  key C.SUP_GST,
  key C.BaseUnit,
  key C.TransactionCurrency,
  key C.CompanyCodeCurrency,
  key C.AmountInCompanyCodeCurrency ,
  key C.Quantity,
  key C.TAXABLE_AMT,
  key C.Cgst_amt,
  key C.sgst_amt,
  key C.igst_amt,
  key C.cgst_rate,
  key C.sgst_rate,
  key C.igst_rate,
  key C.INVOICE_AMT,
      C.REPORT,
      '' as SupplierFullName,
      '' as IN_HSNOrSACCode
//      C.YY1_Transporter_MIH,
//      C.YY1_GRRRNo_MIH,
//      C.YY1_BillofEntryDate_MIH,
//      C.YY1_BillofEntryNo_MIH,
//      C.YY1_BillofEntryValue_MIHC,
//      C.YY1_BillofEntryValue_MIH,
//      C.YY1_EWAYBILLNO_MIH,
//      C.YY1_GSTIN_MIH,
//      C.YY1_Import_MIH,
//      C.YY1_PortCode_MIH,
//      C.YY1_VehicleNo_MIH
}

union select distinct from ZIN_ELIGABLE_CDS4 as C

{
  key C.CompanyCode,
  key C.AccountingDocument,
  key C.FiscalYear,
  key C.doc_item,
  key C.SupplierInvoice,
  key C.ProductDescription,
  key C.ConsumptionTaxCtrlCode ,
  key C.DocumentDate,
  key C.PostingDate,
  key C.TaxCode,
  key C.Product,
  key C.Plant,
  key C.FiscalPeriod,
  key C.Supplier,
  key C.SupplierName,
  key C.AccountingDocumentType,
  key C.BusinessPlace,
  key C.DocumentReferenceID,
  key C.IN_GSTPlaceOfSupply,
  key C.SUP_GST,
  key C.BaseUnit,
  key C.TransactionCurrency,
  key C.CompanyCodeCurrency,
  key C.AmountInCompanyCodeCurrency  ,
  key C.Quantity,
  key C.TAXABLE_AMT,
  key C.Cgst_amt,
  key C.sgst_amt,
  key C.IGST_AMT,
  key C.cgst_rate,
  key C.sgst_rate,
  key C.IGST_RATE,
  key C.INVOICE_AMT,
      C.REPORT,
   '' as   SupplierFullName,
    '' as  IN_HSNOrSACCode 
//      C.YY1_Transporter_MIH,
//      C.YY1_GRRRNo_MIH,
//      C.YY1_BillofEntryDate_MIH,
//      C.YY1_BillofEntryNo_MIH,
//      C.YY1_BillofEntryValue_MIHC,
//      C.YY1_BillofEntryValue_MIH,
//      C.YY1_EWAYBILLNO_MIH,
//      C.YY1_GSTIN_MIH,
//      C.YY1_Import_MIH,
//      C.YY1_PortCode_MIH,
//      C.YY1_VehicleNo_MIH


}

union select distinct from ZIN_ELIGABLE_RCM_CDS2 as C

{
  key C.CompanyCode,
  key C.AccountingDocument,
  key C.FiscalYear,
  key C.doc_item,
  key C.SupplierInvoice,
  key C.ProductDescription,
  key C.ConsumptionTaxCtrlCode ,
  key C.DocumentDate,
  key C.PostingDate,
  key C.TaxCode,
  key C.Product,
  key C.Plant,
  key C.FiscalPeriod,
  key C.Supplier,
  key C.SupplierName,
  key C.AccountingDocumentType,
  key C.BusinessPlace,
  key C.DocumentReferenceID,
  key C.IN_GSTPlaceOfSupply,
  key C.SUP_GST,
  key C.BaseUnit,
  key C.TransactionCurrency,
  key C.CompanyCodeCurrency,
  key C.AmountInCompanyCodeCurrency  ,
  key C.Quantity,
  key C.TAXABLE_AMT,
  key C.Cgst_amt,
  key C.sgst_amt,
  key C.igst_amt,
  key C.cgst_rate,
  key C.sgst_rate,
  key C.igst_rate,
  key C.INVOICE_AMT,
      C.REPORT,
      '' as SupplierFullName,
      '' as IN_HSNOrSACCode 
//      C.YY1_Transporter_MIH,
//      C.YY1_GRRRNo_MIH,
//      C.YY1_BillofEntryDate_MIH,
//      C.YY1_BillofEntryNo_MIH,
//      C.YY1_BillofEntryValue_MIHC,
//      C.YY1_BillofEntryValue_MIH,
//      C.YY1_EWAYBILLNO_MIH,
//      C.YY1_GSTIN_MIH,
//      C.YY1_Import_MIH,
//      C.YY1_PortCode_MIH,
//      C.YY1_VehicleNo_MIH

}
