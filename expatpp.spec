
Name:		expatpp	
Version:	0.6	
Release:	1%{?dist}
Summary:	C++ layer for expat
Group:		Development/Libraries
License:	BSD
URL:		http://sourceforge.net/projects/expatpp/
Source0:	http://sourceforge.net/projects/expatpp/files/expatpp-git.tar.gz


Buildroot:	%{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildRequires: cmake
BuildRequires: expat-devel

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
%setup -q -n expatpp-git

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
%{_libdir}/*.so.*

%files devel
%{_includedir}/%{name}.h
%{_libdir}/*.so


%changelog
* Thu Oct 18 2012 Mario Ceresa <mrceresa@fedoraproject.org>
- Initial SPEC
