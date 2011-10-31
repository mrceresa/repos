
Buildroot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
Summary:        libodb
Name:           libodb-mysql
Version:        1.4.0
Release:	1
License:        GPL
Group:          Applications/Engineering
Vendor:         Center for Applied Medical Research
Source0:        http://www.codesynthesis.com/download/odb/1.4/libodb-mysql-1.4.0.tar.bz2
URL:            http://www.codesynthesis.com/products/odb/

BuildRequires:	mysql-devel
BuildRequires:	libodb-devel

%description

libodb

%prep
%setup

%build
%configure LDFLAGS="-L/usr/lib64/mysql/" 
make %{?_smp_mflags}

%install
rm -rf %{buildroot}
make install DESTDIR=%{buildroot}
rm -rf %{buildroot}/usr/lib64/libodb-mysql.a
rm -rf %{buildroot}/usr/lib64/libodb-mysql.la

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
%dir %{_defaultdocdir}/%{name}
%{_libdir}/%{name}*.so

%post -p /sbin/ldconfig

%postun -p /sbin/ldconfig

%package        devel
Summary:        libodb-devel
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}

%description devel
libodb-devel

%files devel
%defattr(-,root,root)
%dir %{_includedir}/odb/mysql/
%{_includedir}/odb/mysql/*
%{_libdir}/pkgconfig/%{name}.pc
         

%package        doc
Summary:        libodb-doc
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}

%description doc
libodb-doc

%files doc
%defattr(-,root,root)
%dir %{_defaultdocdir}/%{name}
%{_defaultdocdir}/%{name}/*


%changelog
* Sun Jun 25 2011 Mario Ceresa mrceresa@gmail.com libodb-mysql
- Initial rpm release

