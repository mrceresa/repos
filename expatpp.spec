Name:		expatpp	
Version:	0	
Release:	1.20121019gitd8c1bf8%{?dist}
Summary:	C++ layer for expat
Group:		Development/Libraries
License:	MPLv1.1
URL:		http://sourceforge.net/projects/expatpp/
# svn export -r 6 https://expatpp.svn.sourceforge.net/svnroot/expatpp/trunk/src_pp/ expatpp
# tar cjf  expatpp.tar.bz2 expatpp
Source0:	expatpp.tar.bz2
Patch1:		0001-Added-CMake-config-file.patch
Patch2:		0002-Fix-case-of-required-arg.patch
Patch3:		0003-Include-string-header.patch
Patch4:		0004-Converted-to-lib-standalone-program-layout.patch
Patch5:		0005-Added-test-code.patch
Patch6:		0006-Build-testexpatpp1.patch
Patch7:		0007-Fix-subdir-command.patch
Patch8:		0008-Added-cPack.patch
Patch9:		0009-Install-library.patch
Patch10:	0010-Use-lib-or-lib64-automatically.patch
Patch11:	0011-added-soname-info.patch
Patch12:	0012-Fixed-missing-api-version.patch
Patch13:	0013-Install-header-file.patch
Patch14:	0014-Removed-windows-static-lib-header.patch
Patch15:	0015-Reworked-documentation.patch

Buildroot:	%{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildRequires:	cmake
BuildRequires:	expat-devel

%description
Expatpp is a simple C++ layer to make using the open source expat XML parsing
library vastly easier for complex schemas. It has been used widely in industry
including the Valve Steam project.

%package	devel
Summary:	Headers and development libraries for expatpp
Group:		Development/Libraries
Requires:	%{name}%{?_isa} = %{version}-%{release}

%description devel

You should install this package if you would like to
develop code based on expatpp.

%prep
%setup -q -n expatpp

%patch1 -p1
%patch2 -p1
%patch3 -p1
%patch4 -p1
%patch5 -p1
%patch6 -p1
%patch7 -p1
%patch8 -p1
%patch9 -p1
%patch10 -p1
%patch11 -p1
%patch12 -p1
%patch13 -p1
%patch14 -p1
%patch15 -p1


%build
%cmake -DCMAKE_VERBOSE_MAKEFILE=ON \
       -DBUILD_SHARED_LIBS:BOOL=ON \
       -DCMAKE_BUILD_TYPE:STRING="RelWithDebInfo" .
       
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

%clean
rm -rf $RPM_BUILD_ROOT

%check
ctest .

%post -p /sbin/ldconfig

%postun -p /sbin/ldconfig

%files
%doc CHANGELOG EXTEND TODO
%{_libdir}/*.so.*

%files devel
%{_includedir}/%{name}.h
%{_libdir}/*.so


%changelog
* Sun Oct 28 2012 Mario Ceresa mrceresa fedoraproject org expatpp 0-1.20121019gitd8c1bf8%{?dist}
- Included revision in svn export directive
- Fixed tab/spaces issue
- Fixed revision tag
- Shorted Source tag



* Fri Oct 19 2012 Mario Ceresa mrceresa fedoraproject org expatpp 0.6-20121019gitd8c1bf8%{?dist}
- Added patches and fixed release tag
- Fixed license and doc files

* Thu Oct 18 2012 Mario Ceresa mrceresa fedoraproject org expatpp 0.6-1%{?dist}
- Initial SPEC
