#include <hxcpp.h>

#ifndef INCLUDED_Main
#include <Main.h>
#endif
#ifndef INCLUDED_PathInfo
#include <PathInfo.h>
#endif
#ifndef INCLUDED_Sys
#include <Sys.h>
#endif
#ifndef INCLUDED_haxe_format_JsonParser
#include <haxe/format/JsonParser.h>
#endif
#ifndef INCLUDED_haxe_io_Path
#include <haxe/io/Path.h>
#endif
#ifndef INCLUDED_sys_FileSystem
#include <sys/FileSystem.h>
#endif
#ifndef INCLUDED_sys_io_File
#include <sys/io/File.h>
#endif

Void Main_obj::__construct()
{
	return null();
}

//Main_obj::~Main_obj() { }

Dynamic Main_obj::__CreateEmpty() { return  new Main_obj; }
hx::ObjectPtr< Main_obj > Main_obj::__new()
{  hx::ObjectPtr< Main_obj > result = new Main_obj();
	result->__construct();
	return result;}

Dynamic Main_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Main_obj > result = new Main_obj();
	result->__construct();
	return result;}

Void Main_obj::main( ){
{
		HX_STACK_FRAME("Main","main",0xed0e206e,"Main.main","Main.hx",18,0x087e5c05)
		HX_STACK_LINE(19)
		::String _g = ::Sys_obj::executablePath();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(19)
		::String _g1 = ::haxe::io::Path_obj::directory(_g);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(19)
		Array< ::String > _g2 = Array_obj< ::String >::__new().Add(_g1).Add(HX_CSTRING("UpdateMapsPaths.json"));		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(19)
		::String _g3 = ::haxe::io::Path_obj::join(_g2);		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(19)
		::PathInfo p = ::Main_obj::readPaths(_g3);		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(21)
		::Main_obj::copyMaps(p);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Main_obj,main,(void))

::PathInfo Main_obj::readPaths( ::String P){
	HX_STACK_FRAME("Main","readPaths",0x6ec78fa3,"Main.readPaths","Main.hx",25,0x087e5c05)
	HX_STACK_ARG(P,"P")
	HX_STACK_LINE(26)
	Array< ::String > arr;		HX_STACK_VAR(arr,"arr");
	struct _Function_1_1{
		inline static Dynamic Block( ::String &P){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","Main.hx",26,0x087e5c05)
			{
				HX_STACK_LINE(26)
				::String text = ::sys::io::File_obj::getContent(P);		HX_STACK_VAR(text,"text");
				HX_STACK_LINE(26)
				return ::haxe::format::JsonParser_obj::__new(text)->parseRec();
			}
			return null();
		}
	};
	HX_STACK_LINE(26)
	arr = _Function_1_1::Block(P);
	HX_STACK_LINE(28)
	return ::PathInfo_obj::__new(arr->__get((int)0),arr->__get((int)1));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Main_obj,readPaths,return )

Void Main_obj::copyMaps( ::PathInfo P){
{
		HX_STACK_FRAME("Main","copyMaps",0x13fd4b61,"Main.copyMaps","Main.hx",32,0x087e5c05)
		HX_STACK_ARG(P,"P")
		HX_STACK_LINE(33)
		Array< ::String > sources = ::sys::FileSystem_obj::readDirectory(P->source);		HX_STACK_VAR(sources,"sources");
		HX_STACK_LINE(35)
		{
			HX_STACK_LINE(35)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(35)
			while((true)){
				HX_STACK_LINE(35)
				if ((!(((_g < sources->length))))){
					HX_STACK_LINE(35)
					break;
				}
				HX_STACK_LINE(35)
				::String s = sources->__get(_g);		HX_STACK_VAR(s,"s");
				HX_STACK_LINE(35)
				++(_g);
				HX_STACK_LINE(37)
				::String full_path = ::haxe::io::Path_obj::join(Array_obj< ::String >::__new().Add(P->source).Add(s));		HX_STACK_VAR(full_path,"full_path");
				HX_STACK_LINE(38)
				if ((!(::sys::FileSystem_obj::isDirectory(full_path)))){
					HX_STACK_LINE(40)
					::String cont = ::sys::io::File_obj::getContent(full_path);		HX_STACK_VAR(cont,"cont");
					HX_STACK_LINE(41)
					::String _g1 = ::haxe::io::Path_obj::join(Array_obj< ::String >::__new().Add(P->dest).Add(s));		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(41)
					::sys::io::File_obj::saveContent(_g1,cont);
				}
			}
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Main_obj,copyMaps,(void))


Main_obj::Main_obj()
{
}

Dynamic Main_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"main") ) { return main_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"copyMaps") ) { return copyMaps_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"readPaths") ) { return readPaths_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Main_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void Main_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("main"),
	HX_CSTRING("readPaths"),
	HX_CSTRING("copyMaps"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Main_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Main_obj::__mClass,"__mClass");
};

#endif

Class Main_obj::__mClass;

void Main_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("Main"), hx::TCanCast< Main_obj> ,sStaticFields,sMemberFields,
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

void Main_obj::__boot()
{
}

