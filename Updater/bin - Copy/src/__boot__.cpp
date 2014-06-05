#include <hxcpp.h>

#include <sys/io/Process.h>
#include <sys/io/_Process/Stdout.h>
#include <sys/io/_Process/Stdin.h>
#include <sys/FileSystem.h>
#include <haxe/io/Path.h>
#include <haxe/io/Input.h>
#include <haxe/io/Error.h>
#include <haxe/io/Eof.h>
#include <haxe/io/Output.h>
#include <haxe/io/Bytes.h>
#include <Sys.h>
#include <StringBuf.h>
#include <Std.h>
#include <Main.h>
#include <EReg.h>
#include <cpp/Lib.h>

void __files__boot();

void __boot_all()
{
__files__boot();
hx::RegisterResources( hx::GetResources() );
::sys::io::Process_obj::__register();
::sys::io::_Process::Stdout_obj::__register();
::sys::io::_Process::Stdin_obj::__register();
::sys::FileSystem_obj::__register();
::haxe::io::Path_obj::__register();
::haxe::io::Input_obj::__register();
::haxe::io::Error_obj::__register();
::haxe::io::Eof_obj::__register();
::haxe::io::Output_obj::__register();
::haxe::io::Bytes_obj::__register();
::Sys_obj::__register();
::StringBuf_obj::__register();
::Std_obj::__register();
::Main_obj::__register();
::EReg_obj::__register();
::cpp::Lib_obj::__register();
::cpp::Lib_obj::__boot();
::EReg_obj::__boot();
::Main_obj::__boot();
::Std_obj::__boot();
::StringBuf_obj::__boot();
::Sys_obj::__boot();
::haxe::io::Bytes_obj::__boot();
::haxe::io::Output_obj::__boot();
::haxe::io::Eof_obj::__boot();
::haxe::io::Error_obj::__boot();
::haxe::io::Input_obj::__boot();
::haxe::io::Path_obj::__boot();
::sys::FileSystem_obj::__boot();
::sys::io::_Process::Stdin_obj::__boot();
::sys::io::_Process::Stdout_obj::__boot();
::sys::io::Process_obj::__boot();
}

