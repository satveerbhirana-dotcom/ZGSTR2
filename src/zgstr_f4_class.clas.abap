CLASS zgstr_f4_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
    CLASS-METHODS uploaddata .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZGSTR_F4_CLASS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main .
    me->uploaddata(  ) .
  ENDMETHOD.


  METHOD uploaddata .
    DATA : lttable TYPE TABLE OF zgstreport_f4.

    DATA action TYPE string .
*
*    IF action = '1' .
      lttable = VALUE #(
      ( rep_type =  'GSTR1' subrep_type = 'B2B'  zdelete = ' '  )
      ( rep_type =  'GSTR1' subrep_type = 'B2CL/B2CS' zdelete = ' '  )
*      ( rep_type =  'GSTR1' subrep_type = 'B2CS' zdelete = 'X'  )
      ( rep_type =  'GSTR1' subrep_type = 'CDNR' zdelete = ' '  )
      ( rep_type =  'GSTR1' subrep_type = 'CDNUR' zdelete = ' '  )
      ( rep_type =  'GSTR1' subrep_type = 'EXPORT' zdelete = ''  )
      ( rep_type =  'GSTR1' subrep_type = 'SALES' zdelete = 'X'  )
*      ( rep_type =  'GSTR1' subrep_type = 'RCM DOCUMENT' zdelete = ''  )
*      ( rep_type =  'GSTR1' subrep_type = 'JOB WORK CHALLAN' zdelete = ''  )
      ).
*    ENDIF .

 IF ACTION = '2' .

    lttable = VALUE #(

    ( rep_type =  'GSTR2' subrep_type = 'B2B'   zdelete = ' '  )
    ( rep_type =  'GSTR2' subrep_type = 'B2CS'  zdelete = 'X'  )
    ( rep_type =  'GSTR2' subrep_type = 'B2CL/B2CS'  zdelete = ' '  )
    ( rep_type =  'GSTR2' subrep_type = 'CDNR'  zdelete = ' '  )
    ( rep_type =  'GSTR2' subrep_type = 'CDNUR' zdelete = ' '  )
    ( rep_type =  'GSTR2' subrep_type = 'IMPORT' zdelete = ' '  )
    ( rep_type =  'GSTR2' subrep_type = 'EXPORT' zdelete = 'X'  )
    ( rep_type =  'GSTR2' subrep_type = 'RCM REGISTER'  zdelete = ' '  )
    ( rep_type =  'GSTR2' subrep_type = 'RCM UN REGISTER' zdelete = ' '  )
    ( rep_type =  'GSTR2' subrep_type = 'IN_ELIGBLE' zdelete = ' '  )
    ( rep_type =  'GSTR2' subrep_type = 'IN_ELIGBLE_RCM' zdelete = ' '  )
    ( rep_type =  'GSTR2' subrep_type = 'RCM' zdelete = 'X'  )

    ( rep_type =  'GSTR2' subrep_type = 'RCM_R'  zdelete = 'X'  )
    ( rep_type =  'GSTR2' subrep_type = 'RCM_UR' zdelete = 'X'  )
    ( rep_type =  'GSTR2' subrep_type = 'IN_ELG' zdelete = 'X'  )
    ( rep_type =  'GSTR2' subrep_type = 'IN_ELG_RCM' zdelete = 'X'  )
    ).
ENDIF .


    MODIFY zgstreport_f4 FROM TABLE @lttable .
    COMMIT WORK AND WAIT .

  ENDMETHOD.
ENDCLASS.
