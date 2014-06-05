#include <hxcpp.h>

#ifndef INCLUDED_Main
#include <Main.h>
#endif
#ifndef INCLUDED_Sys
#include <Sys.h>
#endif
#ifndef INCLUDED_cpp_Lib
#include <cpp/Lib.h>
#endif
#ifndef INCLUDED_haxe_io_Eof
#include <haxe/io/Eof.h>
#endif
#ifndef INCLUDED_haxe_io_Input
#include <haxe/io/Input.h>
#endif
#ifndef INCLUDED_haxe_io_Path
#include <haxe/io/Path.h>
#endif
#ifndef INCLUDED_sys_FileSystem
#include <sys/FileSystem.h>
#endif
#ifndef INCLUDED_sys_io_Process
#include <sys/io/Process.h>
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
		Array< ::String > _g = ::Sys_obj::args();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(19)
		::String _g1 = _g->__get((int)0);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(19)
		::Main_obj::downloadFile(_g1);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Main_obj,main,(void))

Void Main_obj::downloadFile( ::String URL){
{
		HX_STACK_FRAME("Main","downloadFile",0x70c66f59,"Main.downloadFile","Main.hx",23,0x087e5c05)
		HX_STACK_ARG(URL,"URL")
		HX_STACK_LINE(24)
		::String _g = ::Sys_obj::executablePath();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(24)
		::String _g1 = ::haxe::io::Path_obj::directory(_g);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(24)
		Array< ::String > _g2 = Array_obj< ::String >::__new().Add(_g1).Add(HX_CSTRING("aria2c.exe"));		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(24)
		::String _g3 = ::haxe::io::Path_obj::join(_g2);		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(28)
		::String _g4 = ::Sys_obj::executablePath();		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(28)
		::String _g5 = ::haxe::io::Path_obj::directory(_g4);		HX_STACK_VAR(_g5,"_g5");
		HX_STACK_LINE(25)
		Array< ::String > _g6 = Array_obj< ::String >::__new().Add(URL).Add(HX_CSTRING("-d")).Add(_g5).Add(HX_CSTRING("--check-certificate=false")).Add(HX_CSTRING("--allow-overwrite=true")).Add(HX_CSTRING("--auto-file-renaming=false"));		HX_STACK_VAR(_g6,"_g6");
		HX_STACK_LINE(24)
		::sys::io::Process p = ::sys::io::Process_obj::__new(_g3,_g6);		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(36)
		while((true)){
			HX_STACK_LINE(38)
			try
			{
			HX_STACK_CATCHABLE(::haxe::io::Eof, 0);
			{
				HX_STACK_LINE(40)
				::String _g7 = p->_stdout->readLine();		HX_STACK_VAR(_g7,"_g7");
				HX_STACK_LINE(40)
				::cpp::Lib_obj::println(_g7);
			}
			}
			catch(Dynamic __e){
				if (__e.IsClass< ::haxe::io::Eof >() ){
					HX_STACK_BEGIN_CATCH
					::haxe::io::Eof e = __e;{
						HX_STACK_LINE(44)
						break;
					}
				}
				else {
				    HX_STACK_DO_THROW(__e);
				}
			}
		}
		HX_STACK_LINE(48)
		::cpp::Lib_obj::println(HX_CSTRING("Began unzipping."));
		HX_STACK_LINE(49)
		::Main_obj::unzip();
		HX_STACK_LINE(50)
		::Sys_obj::exit((int)0);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Main_obj,downloadFile,(void))

Void Main_obj::unzip( ){
{
		HX_STACK_FRAME("Main","unzip",0x23278c53,"Main.unzip","Main.hx",54,0x087e5c05)
		HX_STACK_LINE(59)
		::String _g = ::Sys_obj::executablePath();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(59)
		::String _g1 = ::haxe::io::Path_obj::directory(_g);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(59)
		Array< ::String > _g2 = Array_obj< ::String >::__new().Add(_g1).Add(HX_CSTRING("SkullClient.zip"));		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(59)
		::String _g3 = ::haxe::io::Path_obj::join(_g2);		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(60)
		::String _g4 = ::Sys_obj::executablePath();		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(60)
		::String _g5 = ::haxe::io::Path_obj::directory(_g4);		HX_STACK_VAR(_g5,"_g5");
		HX_STACK_LINE(60)
		::String _g6 = ::haxe::io::Path_obj::directory(_g5);		HX_STACK_VAR(_g6,"_g6");
		HX_STACK_LINE(56)
		Array< ::String > _g7 = Array_obj< ::String >::__new().Add(HX_CSTRING("-e")).Add(HX_CSTRING("-p")).Add(_g3).Add(_g6);		HX_STACK_VAR(_g7,"_g7");
		HX_STACK_LINE(55)
		::sys::io::Process p = ::sys::io::Process_obj::__new(HX_CSTRING("FBZip.exe"),_g7);		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(63)
		while((true)){
			HX_STACK_LINE(65)
			try
			{
			HX_STACK_CATCHABLE(::haxe::io::Eof, 0);
			{
				HX_STACK_LINE(67)
				::String _g8 = p->_stdout->readLine();		HX_STACK_VAR(_g8,"_g8");
				HX_STACK_LINE(67)
				::cpp::Lib_obj::println(_g8);
			}
			}
			catch(Dynamic __e){
				if (__e.IsClass< ::haxe::io::Eof >() ){
					HX_STACK_BEGIN_CATCH
					::haxe::io::Eof e = __e;{
						HX_STACK_LINE(71)
						break;
					}
				}
				else {
				    HX_STACK_DO_THROW(__e);
				}
			}
		}
		HX_STACK_LINE(75)
		::String _g9 = ::Sys_obj::executablePath();		HX_STACK_VAR(_g9,"_g9");
		HX_STACK_LINE(75)
		::String _g10 = ::haxe::io::Path_obj::directory(_g9);		HX_STACK_VAR(_g10,"_g10");
		HX_STACK_LINE(75)
		Array< ::String > _g11 = Array_obj< ::String >::__new().Add(_g10).Add(HX_CSTRING("SkullClient.zip"));		HX_STACK_VAR(_g11,"_g11");
		HX_STACK_LINE(75)
		::String _g12 = ::haxe::io::Path_obj::join(_g11);		HX_STACK_VAR(_g12,"_g12");
		HX_STACK_LINE(75)
		::sys::FileSystem_obj::deleteFile(_g12);
		HX_STACK_LINE(77)
		::cpp::Lib_obj::println(HX_CSTRING(""));
		HX_STACK_LINE(78)
		::cpp::Lib_obj::println(HX_CSTRING("Done updating!"));
		HX_STACK_LINE(80)
		::sys::io::Process_obj::__new(HX_CSTRING("SkullRush.exe"),Array_obj< ::String >::__new());
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Main_obj,unzip,(void))


Main_obj::Main_obj()
{
}

Dynamic Main_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"main") ) { return main_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"unzip") ) { return unzip_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"downloadFile") ) { return downloadFile_dyn(); }
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
	HX_CSTRING("downloadFile"),
	HX_CSTRING("unzip"),
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

