#include <hxcpp.h>

#ifndef INCLUDED_EReg
#include <EReg.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_StringBuf
#include <StringBuf.h>
#endif
#ifndef INCLUDED_cpp_Lib
#include <cpp/Lib.h>
#endif

Void EReg_obj::__construct(::String r,::String opt)
{
HX_STACK_FRAME("EReg","new",0x8b859e81,"EReg.new","C:\\HaxeToolkit\\haxe\\std/cpp/_std/EReg.hx",28,0xa4513ee9)
HX_STACK_THIS(this)
HX_STACK_ARG(r,"r")
HX_STACK_ARG(opt,"opt")
{
	HX_STACK_LINE(29)
	Array< ::String > a = opt.split(HX_CSTRING("g"));		HX_STACK_VAR(a,"a");
	HX_STACK_LINE(30)
	this->global = (a->length > (int)1);
	HX_STACK_LINE(31)
	if ((this->global)){
		HX_STACK_LINE(32)
		::String _g = a->join(HX_CSTRING(""));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(32)
		opt = _g;
	}
	HX_STACK_LINE(33)
	Dynamic _g1 = ::EReg_obj::regexp_new_options(r,opt);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(33)
	this->r = _g1;
}
;
	return null();
}

//EReg_obj::~EReg_obj() { }

Dynamic EReg_obj::__CreateEmpty() { return  new EReg_obj; }
hx::ObjectPtr< EReg_obj > EReg_obj::__new(::String r,::String opt)
{  hx::ObjectPtr< EReg_obj > result = new EReg_obj();
	result->__construct(r,opt);
	return result;}

Dynamic EReg_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< EReg_obj > result = new EReg_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

::String EReg_obj::replace( ::String s,::String by){
	HX_STACK_FRAME("EReg","replace",0xae923ad5,"EReg.replace","C:\\HaxeToolkit\\haxe\\std/cpp/_std/EReg.hx",98,0xa4513ee9)
	HX_STACK_THIS(this)
	HX_STACK_ARG(s,"s")
	HX_STACK_ARG(by,"by")
	HX_STACK_LINE(99)
	::StringBuf b = ::StringBuf_obj::__new();		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(100)
	int pos = (int)0;		HX_STACK_VAR(pos,"pos");
	HX_STACK_LINE(101)
	int len = s.length;		HX_STACK_VAR(len,"len");
	HX_STACK_LINE(102)
	Array< ::String > a = by.split(HX_CSTRING("$"));		HX_STACK_VAR(a,"a");
	HX_STACK_LINE(103)
	bool first = true;		HX_STACK_VAR(first,"first");
	HX_STACK_LINE(104)
	while((true)){
		HX_STACK_LINE(105)
		if ((!(::EReg_obj::regexp_match(this->r,s,pos,len)))){
			HX_STACK_LINE(106)
			break;
		}
		HX_STACK_LINE(107)
		Dynamic p = ::EReg_obj::regexp_matched_pos(this->r,(int)0);		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(108)
		if (((bool((p->__Field(HX_CSTRING("len"),true) == (int)0)) && bool(!(first))))){
			HX_STACK_LINE(109)
			if (((p->__Field(HX_CSTRING("pos"),true) == s.length))){
				HX_STACK_LINE(110)
				break;
			}
			HX_STACK_LINE(111)
			hx::AddEq(p->__FieldRef(HX_CSTRING("pos")),(int)1);
		}
		HX_STACK_LINE(113)
		{
			HX_STACK_LINE(113)
			::String _g = s.substr(pos,(p->__Field(HX_CSTRING("pos"),true) - pos));		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(113)
			b->b->push(_g);
		}
		HX_STACK_LINE(114)
		if (((a->length > (int)0))){
			HX_STACK_LINE(115)
			b->add(a->__get((int)0));
		}
		HX_STACK_LINE(116)
		int i = (int)1;		HX_STACK_VAR(i,"i");
		HX_STACK_LINE(117)
		while((true)){
			HX_STACK_LINE(117)
			if ((!(((i < a->length))))){
				HX_STACK_LINE(117)
				break;
			}
			HX_STACK_LINE(118)
			::String k = a->__get(i);		HX_STACK_VAR(k,"k");
			HX_STACK_LINE(119)
			Dynamic c = k.charCodeAt((int)0);		HX_STACK_VAR(c,"c");
			HX_STACK_LINE(121)
			if (((bool((c >= (int)49)) && bool((c <= (int)57))))){
				HX_STACK_LINE(122)
				int _g1 = ::Std_obj::_int(c);		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(122)
				int _g2 = (_g1 - (int)48);		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(122)
				Dynamic p1;		HX_STACK_VAR(p1,"p1");
				HX_STACK_LINE(122)
				try
				{
				HX_STACK_CATCHABLE(::String, 0);
				{
					HX_STACK_LINE(122)
					p1 = ::EReg_obj::regexp_matched_pos(this->r,_g2);
				}
				}
				catch(Dynamic __e){
					if (__e.IsClass< ::String >() ){
						HX_STACK_BEGIN_CATCH
						::String e = __e;{
							HX_STACK_LINE(122)
							p1 = null();
						}
					}
					else {
					    HX_STACK_DO_THROW(__e);
					}
				}
				HX_STACK_LINE(123)
				if (((p1 == null()))){
					HX_STACK_LINE(124)
					b->add(HX_CSTRING("$"));
					HX_STACK_LINE(125)
					b->add(k);
				}
				else{
					HX_STACK_LINE(127)
					{
						HX_STACK_LINE(127)
						::String _g3 = s.substr(p1->__Field(HX_CSTRING("pos"),true),p1->__Field(HX_CSTRING("len"),true));		HX_STACK_VAR(_g3,"_g3");
						HX_STACK_LINE(127)
						b->b->push(_g3);
					}
					HX_STACK_LINE(128)
					{
						HX_STACK_LINE(128)
						::String _g4 = k.substr((int)1,(k.length - (int)1));		HX_STACK_VAR(_g4,"_g4");
						HX_STACK_LINE(128)
						b->b->push(_g4);
					}
				}
			}
			else{
				HX_STACK_LINE(130)
				if (((c == null()))){
					HX_STACK_LINE(131)
					b->add(HX_CSTRING("$"));
					HX_STACK_LINE(132)
					(i)++;
					HX_STACK_LINE(133)
					::String k2 = a->__get(i);		HX_STACK_VAR(k2,"k2");
					HX_STACK_LINE(134)
					if (((bool((k2 != null())) && bool((k2.length > (int)0))))){
						HX_STACK_LINE(135)
						b->add(k2);
					}
				}
				else{
					HX_STACK_LINE(137)
					b->add((HX_CSTRING("$") + k));
				}
			}
			HX_STACK_LINE(138)
			(i)++;
		}
		HX_STACK_LINE(140)
		int tot = ((p->__Field(HX_CSTRING("pos"),true) + p->__Field(HX_CSTRING("len"),true)) - pos);		HX_STACK_VAR(tot,"tot");
		HX_STACK_LINE(141)
		hx::AddEq(pos,tot);
		HX_STACK_LINE(142)
		hx::SubEq(len,tot);
		HX_STACK_LINE(143)
		first = false;
		HX_STACK_LINE(104)
		if ((!(this->global))){
			HX_STACK_LINE(104)
			break;
		}
	}
	HX_STACK_LINE(145)
	{
		HX_STACK_LINE(145)
		::String _g5 = s.substr(pos,len);		HX_STACK_VAR(_g5,"_g5");
		HX_STACK_LINE(145)
		b->b->push(_g5);
	}
	HX_STACK_LINE(146)
	return b->b->join(HX_CSTRING(""));
}


HX_DEFINE_DYNAMIC_FUNC2(EReg_obj,replace,return )

Dynamic EReg_obj::regexp_new_options;

Dynamic EReg_obj::regexp_match;

Dynamic EReg_obj::regexp_matched_pos;


EReg_obj::EReg_obj()
{
}

void EReg_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(EReg);
	HX_MARK_MEMBER_NAME(r,"r");
	HX_MARK_MEMBER_NAME(global,"global");
	HX_MARK_END_CLASS();
}

void EReg_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(r,"r");
	HX_VISIT_MEMBER_NAME(global,"global");
}

Dynamic EReg_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"r") ) { return r; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"global") ) { return global; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"replace") ) { return replace_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"regexp_match") ) { return regexp_match; }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"regexp_new_options") ) { return regexp_new_options; }
		if (HX_FIELD_EQ(inName,"regexp_matched_pos") ) { return regexp_matched_pos; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic EReg_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"r") ) { r=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"global") ) { global=inValue.Cast< bool >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"regexp_match") ) { regexp_match=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"regexp_new_options") ) { regexp_new_options=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"regexp_matched_pos") ) { regexp_matched_pos=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void EReg_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("r"));
	outFields->push(HX_CSTRING("global"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("regexp_new_options"),
	HX_CSTRING("regexp_match"),
	HX_CSTRING("regexp_matched_pos"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(EReg_obj,r),HX_CSTRING("r")},
	{hx::fsBool,(int)offsetof(EReg_obj,global),HX_CSTRING("global")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("r"),
	HX_CSTRING("global"),
	HX_CSTRING("replace"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(EReg_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(EReg_obj::regexp_new_options,"regexp_new_options");
	HX_MARK_MEMBER_NAME(EReg_obj::regexp_match,"regexp_match");
	HX_MARK_MEMBER_NAME(EReg_obj::regexp_matched_pos,"regexp_matched_pos");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(EReg_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(EReg_obj::regexp_new_options,"regexp_new_options");
	HX_VISIT_MEMBER_NAME(EReg_obj::regexp_match,"regexp_match");
	HX_VISIT_MEMBER_NAME(EReg_obj::regexp_matched_pos,"regexp_matched_pos");
};

#endif

Class EReg_obj::__mClass;

void EReg_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("EReg"), hx::TCanCast< EReg_obj> ,sStaticFields,sMemberFields,
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

void EReg_obj::__boot()
{
	regexp_new_options= ::cpp::Lib_obj::load(HX_CSTRING("regexp"),HX_CSTRING("regexp_new_options"),(int)2);
	regexp_match= ::cpp::Lib_obj::load(HX_CSTRING("regexp"),HX_CSTRING("regexp_match"),(int)4);
	regexp_matched_pos= ::cpp::Lib_obj::load(HX_CSTRING("regexp"),HX_CSTRING("regexp_matched_pos"),(int)2);
}

