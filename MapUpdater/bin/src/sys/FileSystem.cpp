#include <hxcpp.h>

#ifndef INCLUDED_cpp_Lib
#include <cpp/Lib.h>
#endif
#ifndef INCLUDED_haxe_io_Path
#include <haxe/io/Path.h>
#endif
#ifndef INCLUDED_sys_FileSystem
#include <sys/FileSystem.h>
#endif
#ifndef INCLUDED_sys__FileSystem_FileKind
#include <sys/_FileSystem/FileKind.h>
#endif
namespace sys{

Void FileSystem_obj::__construct()
{
	return null();
}

//FileSystem_obj::~FileSystem_obj() { }

Dynamic FileSystem_obj::__CreateEmpty() { return  new FileSystem_obj; }
hx::ObjectPtr< FileSystem_obj > FileSystem_obj::__new()
{  hx::ObjectPtr< FileSystem_obj > result = new FileSystem_obj();
	result->__construct();
	return result;}

Dynamic FileSystem_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< FileSystem_obj > result = new FileSystem_obj();
	result->__construct();
	return result;}

::sys::_FileSystem::FileKind FileSystem_obj::kind( ::String path){
	HX_STACK_FRAME("sys.FileSystem","kind",0xa0dedc96,"sys.FileSystem.kind","C:\\HaxeToolkit\\haxe\\std/cpp/_std/sys/FileSystem.hx",56,0xb7079c8b)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(57)
	::String _g = ::haxe::io::Path_obj::removeTrailingSlashes(path);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(57)
	::String k = ::sys::FileSystem_obj::sys_file_type(_g);		HX_STACK_VAR(k,"k");
	HX_STACK_LINE(58)
	::String _switch_1 = (k);
	if (  ( _switch_1==HX_CSTRING("file"))){
		HX_STACK_LINE(59)
		return ::sys::_FileSystem::FileKind_obj::kfile;
	}
	else if (  ( _switch_1==HX_CSTRING("dir"))){
		HX_STACK_LINE(60)
		return ::sys::_FileSystem::FileKind_obj::kdir;
	}
	else  {
		HX_STACK_LINE(61)
		return ::sys::_FileSystem::FileKind_obj::kother(k);
	}
;
;
	HX_STACK_LINE(58)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FileSystem_obj,kind,return )

bool FileSystem_obj::isDirectory( ::String path){
	HX_STACK_FRAME("sys.FileSystem","isDirectory",0x6c577a21,"sys.FileSystem.isDirectory","C:\\HaxeToolkit\\haxe\\std/cpp/_std/sys/FileSystem.hx",65,0xb7079c8b)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(66)
	::sys::_FileSystem::FileKind _g = ::sys::FileSystem_obj::kind(path);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(66)
	return (_g == ::sys::_FileSystem::FileKind_obj::kdir);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FileSystem_obj,isDirectory,return )

Array< ::String > FileSystem_obj::readDirectory( ::String path){
	HX_STACK_FRAME("sys.FileSystem","readDirectory",0x0619f8b5,"sys.FileSystem.readDirectory","C:\\HaxeToolkit\\haxe\\std/cpp/_std/sys/FileSystem.hx",90,0xb7079c8b)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(90)
	return ::sys::FileSystem_obj::sys_read_dir(path);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FileSystem_obj,readDirectory,return )

Dynamic FileSystem_obj::sys_file_type;

Dynamic FileSystem_obj::sys_read_dir;


FileSystem_obj::FileSystem_obj()
{
}

Dynamic FileSystem_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"kind") ) { return kind_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"isDirectory") ) { return isDirectory_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"sys_read_dir") ) { return sys_read_dir; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"readDirectory") ) { return readDirectory_dyn(); }
		if (HX_FIELD_EQ(inName,"sys_file_type") ) { return sys_file_type; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic FileSystem_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 12:
		if (HX_FIELD_EQ(inName,"sys_read_dir") ) { sys_read_dir=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"sys_file_type") ) { sys_file_type=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void FileSystem_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("kind"),
	HX_CSTRING("isDirectory"),
	HX_CSTRING("readDirectory"),
	HX_CSTRING("sys_file_type"),
	HX_CSTRING("sys_read_dir"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FileSystem_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(FileSystem_obj::sys_file_type,"sys_file_type");
	HX_MARK_MEMBER_NAME(FileSystem_obj::sys_read_dir,"sys_read_dir");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FileSystem_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(FileSystem_obj::sys_file_type,"sys_file_type");
	HX_VISIT_MEMBER_NAME(FileSystem_obj::sys_read_dir,"sys_read_dir");
};

#endif

Class FileSystem_obj::__mClass;

void FileSystem_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("sys.FileSystem"), hx::TCanCast< FileSystem_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatics
#endif
#ifdef HXCPP_SCRIPTABLE
    , sMemberStorageInfo
#endif
);
}

void FileSystem_obj::__boot()
{
	sys_file_type= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("sys_file_type"),(int)1);
	sys_read_dir= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("sys_read_dir"),(int)1);
}

} // end namespace sys
