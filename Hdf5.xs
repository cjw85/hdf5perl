#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <hdf5.h>

#include "const-c.inc"

#include <stdint.h>

MODULE = Hdf5		PACKAGE = Hdf5		

INCLUDE: const-xs.inc

hid_t
get_H5T_STD_I64LE()
CODE:
	RETVAL = H5T_STD_I64LE;
OUTPUT:
	RETVAL

hid_t
get_H5T_STD_U64LE()
CODE:
	RETVAL = H5T_STD_U64LE;
OUTPUT:
	RETVAL

hid_t
get_H5T_C_S1()
CODE:
	RETVAL = H5T_C_S1;
OUTPUT:
	RETVAL

hid_t
get_H5T_STRING()
CODE:
	RETVAL = H5T_STRING;
OUTPUT:
	RETVAL

hid_t
get_H5T_STD_I8LE()
CODE:
	RETVAL = H5T_STD_I8LE;
OUTPUT:
	RETVAL

hid_t
get_H5T_STD_U16LE()
CODE:
	RETVAL = H5T_STD_U16LE_g;
OUTPUT:
	RETVAL

hid_t
get_H5T_STD_I16LE()
CODE:
	RETVAL = H5T_STD_I16LE_g;
OUTPUT:
	RETVAL

hid_t
get_H5T_STD_I32LE()
CODE:
	RETVAL = H5T_STD_I32LE_g;
OUTPUT:
	RETVAL

hid_t
get_H5T_STD_U32LE()
CODE:
	RETVAL = H5T_STD_U32LE_g;
OUTPUT:
	RETVAL

hid_t
get_H5T_IEEE_F32LE()
CODE:
	RETVAL = H5T_IEEE_F32LE;
OUTPUT:
	RETVAL

hid_t
get_H5T_IEEE_F64LE()
CODE:
	RETVAL = H5T_IEEE_F64LE;
OUTPUT:
	RETVAL

H5T_class_t
get_H5T_COMPOUND()
CODE:
	RETVAL = H5T_COMPOUND;
OUTPUT:
	RETVAL

hid_t
get_H5S_SELECT_SET()
CODE:
	RETVAL = H5S_SELECT_SET;
OUTPUT:
	RETVAL


hid_t
get_H5T_NATIVE_INT()
CODE:
	RETVAL = H5T_NATIVE_INT_g;
OUTPUT:
	RETVAL

hid_t
get_H5T_NATIVE_FLOAT()
CODE:
	RETVAL = H5T_NATIVE_FLOAT_g;
OUTPUT:
	RETVAL

hid_t
get_H5T_NATIVE_DOUBLE()
CODE:
	RETVAL = H5T_NATIVE_DOUBLE_g;
OUTPUT:
	RETVAL

hid_t 
H5Fopen(name,flags,access_id)
	const char *name
	unsigned int flags
	hid_t access_id

hid_t
H5Fcreate(name,flags,create_id,access_id)
	const char *name
	unsigned int flags
	hid_t create_id
	hid_t access_id

hid_t
H5Dopen2(loc_id,name,dapl_id)
	hid_t loc_id
	const char *name
	hid_t dapl_id

hid_t
H5Dget_type(dataset)
	hid_t dataset

H5T_order_t
H5Tget_order(dtype_id)
	hid_t	dtype_id

size_t
H5Tget_size(dtype_id)
	hid_t	dtype_id

hid_t
H5Dget_space(dataset_id)
	hid_t	dataset_id

int
H5Sget_simple_extent_ndims(space_id)
	hid_t space_id

int
H5Sget_simple_extent_dims(space_id,dims,maxdims)
	hid_t	space_id
	AV * dims
	AV * maxdims
CODE:
	hsize_t *cdims    = malloc((av_len(dims)+1)   *sizeof(hsize_t));
	hsize_t *cmaxdims = malloc((av_len(maxdims)+1)*sizeof(hsize_t));
	RETVAL = H5Sget_simple_extent_dims(space_id,cdims,cmaxdims);
	int i=0;
	for(i=0;i<=av_len(dims);i++) { 
		av_store(dims,i,newSVnv(cdims[i]));
		av_store(maxdims,i,newSVnv(cmaxdims[i]));
	}
	free(cdims);
	free(cmaxdims);
OUTPUT:
	RETVAL

hid_t
H5Screate_simple(rank,current_dims,maximum_dims)
	int	rank
	hsize_t * current_dims
	hsize_t * maximum_dims
	
hid_t
H5Screate_simpleNULL(rank,current_dims)
	int	rank
	AV * current_dims
CODE:
	int i=0;
	hsize_t d[100];
	for(i=0;i<rank;i++) {
		SV** e = av_fetch(current_dims,i,0);
		d[i] = SvNV(*e);
	}
	RETVAL = H5Screate_simple(rank,d,NULL);
OUTPUT:
	RETVAL

hid_t
H5Tcreate(class,size)
	H5T_class_t class
	size_t size

herr_t
H5Tinsert(dtype_id,name,offset,field_id)
	hid_t dtype_id
	const char * name
	size_t offset
	hid_t field_id


herr_t
H5Tclose(datatype)
	hid_t datatype

herr_t
H5Dclose(dataset)
	hid_t dataset

herr_t
H5Sclose(dataspace)
	hid_t dataspace

herr_t
H5Fclose(file)
	hid_t file

herr_t
H5Aclose(attr)
	hid_t attr

herr_t
H5Gclose(group)
	hid_t group

hid_t
H5Tcopy(type_id)
	hid_t	type_id

herr_t
H5Tset_order(type_id,order)
	hid_t	type_id
	H5T_order_t	order

hid_t
H5Dcreate2(loc_id,name,dtype_id,space_id,lcpl_id,dcpl_id,dapl_id)
	hid_t	loc_id
	char *	name
	hid_t	dtype_id
	hid_t	space_id
	hid_t	lcpl_id
	hid_t	dcpl_id
	hid_t	dapl_id

herr_t
H5Dwrite(dataset_id,mem_type_id,mem_space_id,file_space_id,xfer_plist_id,buf)
	hid_t	dataset_id
	hid_t	mem_type_id
	hid_t	mem_space_id
	hid_t	file_space_id
	hid_t	xfer_plist_id
	AV * buf
CODE:
	int i=0;
	unsigned long buffer[100];
	for(i=0;i<=av_len(buf);i++) {
		SV** e = av_fetch(buf,i,0);
		buffer[i] = SvNV(*e);
	}
	RETVAL = H5Dwrite(dataset_id,mem_type_id,mem_space_id,file_space_id,xfer_plist_id,buffer);
OUTPUT:
	RETVAL

herr_t 
H5Dread32(dataset_id,mem_type_id,mem_space_id,file_space_id,xfer_plist_id,buf)
	hid_t dataset_id
	hid_t mem_type_id
	hid_t mem_space_id
	hid_t file_space_id
	hid_t xfer_plist_id
	AV * buf
CODE:
	int32_t *data = malloc(av_len(buf)*sizeof(int32_t));
	RETVAL = H5Dread(dataset_id,mem_type_id,mem_space_id,file_space_id,xfer_plist_id,data);
	int i=0;
	for(i=0;i<=av_len(buf);i++) { 
		av_store(buf,i,newSVnv(data[i]));
	}
	free(data);
OUTPUT:
	RETVAL

herr_t 
H5Dread16(dataset_id,mem_type_id,mem_space_id,file_space_id,xfer_plist_id,buf)
	hid_t dataset_id
	hid_t mem_type_id
	hid_t mem_space_id
	hid_t file_space_id
	hid_t xfer_plist_id
	AV * buf
CODE:
	int16_t *data = malloc(av_len(buf)*sizeof(int16_t));
	RETVAL = H5Dread(dataset_id,mem_type_id,mem_space_id,file_space_id,xfer_plist_id,data);
	int i=0;
	for(i=0;i<=av_len(buf);i++) { 
		av_store(buf,i,newSVnv(data[i]));
	}
	free(data);
OUTPUT:
	RETVAL

herr_t 
H5DreadRaw(dataset_id,mem_type_id,mem_space_id,file_space_id,xfer_plist_id,buf,size)
	hid_t dataset_id
	hid_t mem_type_id
	hid_t mem_space_id
	hid_t file_space_id
	hid_t xfer_plist_id
	SV* buf
	size_t size
CODE:
	size_t read_size=size;

	SvUPGRADE(buf, SVt_PV);
        SvPOK_only(buf);
	char *data = SvGROW(buf,read_size);
	SvCUR_set(buf,read_size);
	RETVAL = H5Dread(dataset_id,mem_type_id,mem_space_id,file_space_id,xfer_plist_id,data);
OUTPUT:
	RETVAL

herr_t 
H5AreadRaw(attribute_id,mem_type_id,buf)
	hid_t attribute_id
	hid_t mem_type_id
	SV* buf
CODE:
	H5A_info_t info;
	H5Aget_info(attribute_id,&info);
	size_t read_size = info.data_size;

	SvUPGRADE(buf, SVt_PV);
        SvPOK_only(buf);
	char *data = SvGROW(buf,read_size);
	SvCUR_set(buf,read_size);
	RETVAL = H5Aread(attribute_id,mem_type_id,data);
OUTPUT:
	RETVAL

	
herr_t
H5Sselect_hyperslab(space_id,op,start,stride,count,block)
	hid_t space_id
	H5S_seloper_t	op
	AV * start
	AV * stride
	AV * count
	AV * block
CODE:
	hsize_t *hstart  = malloc(sizeof(hsize_t)*av_len(start)); 
	hsize_t *hstride = malloc(sizeof(hsize_t)*av_len(stride));
	hsize_t *hcount  = malloc(sizeof(hsize_t)*av_len(count));
	hsize_t *hblock  = malloc(sizeof(hsize_t)*av_len(block));

	int n;
	for(n=0;n<=av_len(start);n++) {
		SV** a = av_fetch(start,n,0);
		hstart[n] = SvNV(*a);
	}

	for(n=0;n<=av_len(stride);n++) {
		SV** b = av_fetch(stride,n,0);
		hstride[n] = SvNV(*b);
	}

	for(n=0;n<=av_len(count);n++) {
		SV** c = av_fetch(count,n,0);
		hcount[n] = SvNV(*c);
	}

	for(n=0;n<=av_len(block);n++) {
		SV** d = av_fetch(block,n,0);
		hblock[n] = SvNV(*d);
	}

	RETVAL = H5Sselect_hyperslab(space_id,op,hstart,hstride,hcount,hblock);
	free(hstart);
	free(hstride);
	free(hcount);
	free(hblock);
OUTPUT:
	RETVAL

hid_t
H5Aopen_name(loc_id,name)
	hid_t	loc_id
	const char * name

herr_t
H5Aread64f(attr_id,mem_type_id,buf)
	hid_t attr_id
	hid_t mem_type_id
	AV * buf
CODE:
	double *data = malloc((av_len(buf)+1)*sizeof(double));
	RETVAL = H5Aread(attr_id,mem_type_id,data);
	int i=0;
	for(i=0;i<=av_len(buf);i++) { 
		av_store(buf,i,newSVnv(data[i]));
	}
	free(data);
OUTPUT:
	RETVAL

hid_t
H5Gopen1(loc_id,name)
	hid_t loc_id
	const char *name

herr_t
H5Gget_num_objs(loc_id,num_obj)
	hid_t loc_id
	AV * num_obj
CODE:
	hsize_t cnum_obj;
	RETVAL = H5Gget_num_objs(loc_id,&cnum_obj);
	av_store(num_obj,0,newSVnv(cnum_obj));
OUTPUT:
	RETVAL

ssize_t
H5Gget_objname_by_idx(loc_id,idx,name,size)
	hid_t loc_id
	hsize_t idx
	SV *name
	size_t size
CODE:
	SvUPGRADE(name, SVt_PV);
        SvPOK_only(name);
	char *data = SvGROW(name,size);
	SvCUR_set(name,size);
	int n=0;
	for(n=0;n<size;n++) data[n] = 0;
	H5Gget_objname_by_idx(loc_id,idx,data,size);
	int len = strlen(data);
	SvCUR_set(name,len);

bool
H5Gget_objtype(loc_id,name,type)
	hid_t loc_id
	const char *name
	SV *type
CODE:
	SvUPGRADE(type, SVt_PV);
        SvPOK_only(type);
	char *data = SvGROW(type,40);
	SvCUR_set(type,40);

	H5G_stat_t info;
	H5Gget_objinfo(loc_id,name,1,&info);
	
	if(info.type == H5G_UNKNOWN)    strcpy(data,"UNKNOWN");
	if(info.type == H5G_GROUP)      strcpy(data,"GROUP");
	if(info.type == H5G_DATASET)    strcpy(data,"DATASET");
	if(info.type == H5G_TYPE)       strcpy(data,"TYPE");
	if(info.type == H5G_LINK)       strcpy(data,"LINK");
	if(info.type == H5G_UDLINK)     strcpy(data,"UDLINK");
	if(info.type == H5G_RESERVED_5) strcpy(data,"RESERVED_5");
	if(info.type == H5G_RESERVED_6) strcpy(data,"RESERVED_6");
	if(info.type == H5G_RESERVED_7) strcpy(data,"RESERVED_7");
	int len = strlen(data);
	SvCUR_set(type,len);
	RETVAL = 1;
OUTPUT:
	RETVAL

int
H5Aget_num_attrs(loc_id)
	hid_t loc_id

hid_t
H5Aopen_idx(loc_id,idx)
	hid_t loc_id
	unsigned int idx


ssize_t
H5Aget_name(attr_id,size,buf)
	hid_t attr_id
	size_t size
	SV *buf
CODE:
	SvUPGRADE(buf, SVt_PV);
        SvPOK_only(buf);
	char *data = SvGROW(buf,size);
	SvCUR_set(buf,size);
	H5Aget_name(attr_id,size,data);
	int len = strlen(data);
	SvCUR_set(buf,len);

bool
H5Tget_class(dtype_id,class)
	hid_t dtype_id
	SV *class
CODE:
	SvUPGRADE(class, SVt_PV);
        SvPOK_only(class);
	char *data = SvGROW(class,40);
	SvCUR_set(class,40);

	H5T_class_t c = H5Tget_class(dtype_id);
	if(c == H5T_INTEGER  ) strcpy(data,"INTEGER");
	if(c == H5T_FLOAT    ) strcpy(data,"FLOAT");
	if(c == H5T_STRING   ) strcpy(data,"STRING");
	if(c == H5T_BITFIELD ) strcpy(data,"BITFIELD");
	if(c == H5T_OPAQUE   ) strcpy(data,"OPAQUE");
	if(c == H5T_COMPOUND ) strcpy(data,"COMPOUND");
	if(c == H5T_REFERENCE) strcpy(data,"REFERENCE");
	if(c == H5T_ENUM     ) strcpy(data,"ENUM");
	if(c == H5T_VLEN     ) strcpy(data,"VLEN");
	if(c == H5T_ARRAY    ) strcpy(data,"ARRAY");
	int len = strlen(data);
	SvCUR_set(class,len);
	RETVAL = 1;
OUTPUT:
	RETVAL

int
H5Tget_nmembers(dtype_id)
	hid_t dtype_id


bool
H5Tget_member_name (datatype,idx,name)
	hid_t datatype
	int idx
	SV *name
CODE:
	char *namestr = H5Tget_member_name(datatype,idx);

	SvUPGRADE(name, SVt_PV);
        SvPOK_only(name);
	char *data = SvGROW(name,strlen(namestr));
	strcpy(data,namestr);
	SvCUR_set(name,strlen(namestr));
	RETVAL = 1;
OUTPUT:
	RETVAL

bool
H5Tget_member_class(dtype_id,idx,class)
	hid_t dtype_id
	int idx
	SV *class
CODE:
	SvUPGRADE(class, SVt_PV);
        SvPOK_only(class);
	char *data = SvGROW(class,40);
	SvCUR_set(class,40);

	H5T_class_t c = H5Tget_member_class(dtype_id,idx);
	if(c == H5T_INTEGER  ) strcpy(data,"INTEGER");
	if(c == H5T_FLOAT    ) strcpy(data,"FLOAT");
	if(c == H5T_STRING   ) strcpy(data,"STRING");
	if(c == H5T_BITFIELD ) strcpy(data,"BITFIELD");
	if(c == H5T_OPAQUE   ) strcpy(data,"OPAQUE");
	if(c == H5T_COMPOUND ) strcpy(data,"COMPOUND");
	if(c == H5T_REFERENCE) strcpy(data,"REFERENCE");
	if(c == H5T_ENUM     ) strcpy(data,"ENUM");
	if(c == H5T_VLEN     ) strcpy(data,"VLEN");
	if(c == H5T_ARRAY    ) strcpy(data,"ARRAY");
	int len = strlen(data);
	SvCUR_set(class,len);
	RETVAL = 1;
OUTPUT:
	RETVAL

hid_t
H5Tget_member_type(dtype_id,field_idx)
	hid_t dtype_id
	unsigned int field_idx

int
H5Tequal(dtype_id1,dtype_id2)
	hid_t dtype_id1
	hid_t dtype_id2

hsize_t
H5Dget_storage_size(dataset_id)
	hid_t dataset_id

hssize_t
H5Sget_simple_extent_npoints(space_id)
	hid_t space_id

hid_t
H5Aget_type(attr_id)
	hid_t attr_id

AV *
get_every_nth(aref, stride, offset)
    SV * aref;
        int stride;
        int offset;
INIT:
    AV * results;
    I32 numvalues = 0;
    int i;
    
    /* Check that aref is a reference, then check that it is an
    array reference, then check that it is non-empty. */
    if ((! SvROK(aref))
    || (SvTYPE(SvRV(aref)) != SVt_PVAV)
    || ((numvalues = av_len((AV *)SvRV(aref))) < 0))
    {
        XSRETURN_UNDEF;
    }

    /* Create the array which holds the return values. */
    results = (AV *) sv_2mortal ((SV *) newAV ());
CODE:
        AV* array;
        array = (AV*)SvRV(aref);
    for (i=offset; i<=numvalues; i+=stride) {
                av_push(results, newSVsv( *av_fetch(array, i, 0) ) );
    }
    RETVAL = results;
OUTPUT:
    RETVAL

void
rescale_array(aref, A, B)
    SV * aref;
    SV * A;
    SV * B;
INIT:
    I32 numvalues = 0;
    int i;
    
    /* Check that aref is a reference, then check that it is an
    array reference, then check that it is non-empty. */
    if ((! SvROK(aref))
    || (SvTYPE(SvRV(aref)) != SVt_PVAV)
    || ((numvalues = av_len((AV *)SvRV(aref))) < 0))
    {
        XSRETURN_UNDEF;
    }
CODE:
    /* Performs the transformation V_i -> (V_i + A) * B  */
    for (i=0; i<=numvalues; i++) {
       SV** elem = av_fetch( (AV*)SvRV(aref), i, 1);
       SV* new_elem = newSVnv( (SvNV(*elem) + SvNV(A)) * SvNV(B) );
       av_store( (AV*)SvRV(aref), i, new_elem );
    }
