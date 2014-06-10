#ifndef INCLUDED_PathInfo
#define INCLUDED_PathInfo

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(PathInfo)


class HXCPP_CLASS_ATTRIBUTES  PathInfo_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef PathInfo_obj OBJ_;
		PathInfo_obj();
		Void __construct(::String Source,::String Dest);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< PathInfo_obj > __new(::String Source,::String Dest);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~PathInfo_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("PathInfo"); }

		::String source;
		::String dest;
};


#endif /* INCLUDED_PathInfo */ 
