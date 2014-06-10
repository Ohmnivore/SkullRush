#ifndef INCLUDED_sys_FileSystem
#define INCLUDED_sys_FileSystem

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(sys,FileSystem)
HX_DECLARE_CLASS2(sys,_FileSystem,FileKind)
namespace sys{


class HXCPP_CLASS_ATTRIBUTES  FileSystem_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef FileSystem_obj OBJ_;
		FileSystem_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< FileSystem_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~FileSystem_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("FileSystem"); }

		static ::sys::_FileSystem::FileKind kind( ::String path);
		static Dynamic kind_dyn();

		static bool isDirectory( ::String path);
		static Dynamic isDirectory_dyn();

		static Array< ::String > readDirectory( ::String path);
		static Dynamic readDirectory_dyn();

		static Dynamic sys_file_type;
		static Dynamic &sys_file_type_dyn() { return sys_file_type;}
		static Dynamic sys_read_dir;
		static Dynamic &sys_read_dir_dyn() { return sys_read_dir;}
};

} // end namespace sys

#endif /* INCLUDED_sys_FileSystem */ 
