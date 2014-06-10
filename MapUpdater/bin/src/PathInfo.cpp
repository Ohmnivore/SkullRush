#include <hxcpp.h>

#ifndef INCLUDED_PathInfo
#include <PathInfo.h>
#endif
#ifndef INCLUDED_Sys
#include <Sys.h>
#endif
#ifndef INCLUDED_haxe_io_Path
#include <haxe/io/Path.h>
#endif

Void PathInfo_obj::__construct(::String Source,::String Dest)
{
HX_STACK_FRAME("PathInfo","new",0x32224345,"PathInfo.new","Main.hx",54,0x087e5c05)
HX_STACK_THIS(this)
HX_STACK_ARG(Source,"Source")
HX_STACK_ARG(Dest,"Dest")
{
	HX_STACK_LINE(55)
	::String _g = ::Sys_obj::executablePath();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(55)
	::String _g1 = ::haxe::io::Path_obj::directory(_g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(55)
	Array< ::String > _g2 = Array_obj< ::String >::__new().Add(_g1).Add(Source);		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(55)
	::String _g3 = ::haxe::io::Path_obj::join(_g2);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(55)
	this->source = _g3;
	HX_STACK_LINE(56)
	::String _g4 = ::Sys_obj::executablePath();		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(56)
	::String _g5 = ::haxe::io::Path_obj::directory(_g4);		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(56)
	Array< ::String > _g6 = Array_obj< ::String >::__new().Add(_g5).Add(Dest);		HX_STACK_VAR(_g6,"_g6");
	HX_STACK_LINE(56)
	::String _g7 = ::haxe::io::Path_obj::join(_g6);		HX_STACK_VAR(_g7,"_g7");
	HX_STACK_LINE(56)
	this->dest = _g7;
}
;
	return null();
}

//PathInfo_obj::~PathInfo_obj() { }

Dynamic PathInfo_obj::__CreateEmpty() { return  new PathInfo_obj; }
hx::ObjectPtr< PathInfo_obj > PathInfo_obj::__new(::String Source,::String Dest)
{  hx::ObjectPtr< PathInfo_obj > result = new PathInfo_obj();
	result->__construct(Source,Dest);
	return result;}

Dynamic PathInfo_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< PathInfo_obj > result = new PathInfo_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}


PathInfo_obj::PathInfo_obj()
{
}

void PathInfo_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(PathInfo);
	HX_MARK_MEMBER_NAME(source,"source");
	HX_MARK_MEMBER_NAME(dest,"dest");
	HX_MARK_END_CLASS();
}

void PathInfo_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(source,"source");
	HX_VISIT_MEMBER_NAME(dest,"dest");
}

Dynamic PathInfo_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"dest") ) { return dest; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"source") ) { return source; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic PathInfo_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"dest") ) { dest=inValue.Cast< ::String >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"source") ) { source=inValue.Cast< ::String >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void PathInfo_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("source"));
	outFields->push(HX_CSTRING("dest"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsString,(int)offsetof(PathInfo_obj,source),HX_CSTRING("source")},
	{hx::fsString,(int)offsetof(PathInfo_obj,dest),HX_CSTRING("dest")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("source"),
	HX_CSTRING("dest"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(PathInfo_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(PathInfo_obj::__mClass,"__mClass");
};

#endif

Class PathInfo_obj::__mClass;

void PathInfo_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("PathInfo"), hx::TCanCast< PathInfo_obj> ,sStaticFields,sMemberFields,
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

void PathInfo_obj::__boot()
{
}

