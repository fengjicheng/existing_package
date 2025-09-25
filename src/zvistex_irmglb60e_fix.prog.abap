*&---------------------------------------------------------------------*
*& Report  ZVISTEX_IRMGLB60E_FIX
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZVISTEX_IRMGLB60E_FIX.



* The first section of this report corrects the following
* table entries in E071 pertaining to Release 60A so that
* the installation tool does not see them as being conflicts
* with the new 60E release.

data: gv_count type i.

tables: e071.

select * from e071 where trkorr = 'SAPK-60A04INIRMGLB'
                  and as4pos in ('000669', '000670',
                  '000671', '000672', '000673').
  e071-pgmid = '*3TR'.
  update e071.
  add 1 to gv_count.
endselect.

select * from e071 where trkorr = 'SAPK-60A05INIRMGLB'
                  and as4pos = '001104'.
  e071-pgmid = '*3TR'.
  update e071.
  add 1 to gv_count.
endselect.

select * from e071 where trkorr = 'SAPK-60A06INIRMGLB'
                  and as4pos in ('001460', '001461',
                  '001462', '001954', '002607').
  e071-pgmid = '*3TR'.
  update e071.
  add 1 to gv_count.
endselect.

select * from e071 where trkorr = 'SAPK-60A08INIRMGLB'
                          and as4pos in ('000676', '000678',
                          '000679', '000680', '000681',
                          '000682', '000683', '000684').
  e071-pgmid = '*3TR'.
  update e071.
  add 1 to gv_count.
endselect.


* The next section of this report corrects the following
* table entries in E071 so that the installation tool does
* not see them as being conflicts with the new 60E release.

* Fixes transactions:
* /IRM/IPARBBDSP
* /IRM/IPARBRDSP
* /IRM/IPARCBDSP
* /IRM/IPARCRDSP
* /IRM/IPARPRDSP
* /IRM/IPARSIDSP

select * from e071 where trkorr = 'SAPK-60DCHINIRMGLB'
                  and as4pos in ('006200',
  '006201',
  '006202',
  '006203',
  '006204',
  '006205').
  e071-pgmid = '*3TR'.
  update e071.
  add 1 to gv_count.
endselect.

select * from e071 where trkorr = 'SAPK-60DCOINIRMGLB'
                  and as4pos in ('009004',
  '009005',
  '009006',
  '009007',
  '009008',
  '009009').
  e071-pgmid = '*3TR'.
  update e071.
  add 1 to gv_count.
endselect.


* The next section of this report corrects the table entries
* in E071 so that the installation tool does not see them as
* being conflicts with the new 60E release. They are for
* SMIM entries which appear on both the global and IP
* packages

select * from e071 where trkorr = 'SAPK-60DCHINIRMIPM'
                  and as4pos in ('004416',
'004419',
'004420',
'004421',
'004422',
'004423',
'004424',
'004425',
'004426',
'004427',
'004428',
'004429',
'004430',
'004431',
'004432',
'004433',
'004436',
'004437',
'004438',
'004439',
'004440',
'004441',
'004442',
'004443',
'004444',
'004445',
'004446',
'004447',
'004448',
'004449',
'004450',
'004451',
'004452',
'004453',
'004454',
'004455',
'004456',
'004457',
'004458',
'004459',
'004460',
'004461',
'004462',
'004463',
'004464',
'004465',
'004467',
'005093',
'005094',
'005095',
'005096',
'005097',
'005099').
  e071-pgmid = '*3TR'.
  update e071.
  add 1 to gv_count.
endselect.

select * from e071 where trkorr = 'SAPK-60DCOINIRMIPM'
                  and as4pos in ('005141',
'005144',
'005145',
'005146',
'005147',
'005148',
'005149',
'005150',
'005151',
'005152',
'005153',
'005154',
'005155',
'005156',
'005157',
'005158',
'005161',
'005162',
'005163',
'005164',
'005165',
'005166',
'005167',
'005168',
'005169',
'005170',
'005171',
'005172',
'005173',
'005174',
'005175',
'005176',
'005177',
'005178',
'005179',
'005180',
'005181',
'005182',
'005183',
'005184',
'005185',
'005186',
'005187',
'005188',
'005189',
'005190',
'005192').
  e071-pgmid = '*3TR'.
  update e071.
  add 1 to gv_count.
endselect.

* SEST (Enterprise Search Template) object causes issues
* in post generation methods, so skip this object
select * from e071 where trkorr = 'SAPK-60ECHINIRMGLB'
                          and as4pos in ('010428').
  e071-pgmid = '*3TR'.
  update e071.
  add 1 to gv_count.
endselect.

select * from e071 where trkorr = 'SAPK-60ECOINIRMGLB'
                          and as4pos in ('006095').
  e071-pgmid = '*3TR'.
  update e071.
  add 1 to gv_count.
endselect.

write: / 'Finished: ', gv_count, ' selected entries were corrected'.
