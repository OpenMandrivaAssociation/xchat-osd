%define name xchat-osd
%define version 1.1
%define release 7

Summary: An osd plugin for xchat
Name: %{name}
Version: %{version}
Release: %{release}
URL: http://www.dmo.ca/projects/xchat-hacks/osd.pl
Source0: osd.pl
License: GPL
Group: Networking/IRC
BuildRoot: %{_tmppath}/%{name}-buildroot
Requires: xchat, perl-X-Osd, xchat-perl

%description
An osd plugin for xchat

%prep

%build

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/%{_libdir}/%{name}
install %SOURCE0  $RPM_BUILD_ROOT/%{_libdir}/%{name}

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%{_libdir}/%{name}/*


%changelog
* Wed Sep 09 2009 Thierry Vignaud <tvignaud@mandriva.com> 1.1-6mdv2010.0
+ Revision: 435058
- rebuild

* Sat Aug 09 2008 Thierry Vignaud <tvignaud@mandriva.com> 1.1-5mdv2009.0
+ Revision: 269764
- rebuild early 2009.0 package (before pixel changes)

* Sun May 11 2008 Funda Wang <fundawang@mandriva.org> 1.1-4mdv2009.0
+ Revision: 205516
- should not be noarch

* Fri Dec 21 2007 Olivier Blin <oblin@mandriva.com> 1.1-3mdv2008.1
+ Revision: 136578
- restore BuildRoot

  + Thierry Vignaud <tvignaud@mandriva.com>
    - kill re-definition of %%buildroot on Pixel's request


* Thu Jun 22 2006 Erwan Velu <erwan@seanodes.com> 1.1-3
- rebuild

* Thu Jun 02 2005 Nicolas Lécureuil <neoclust@mandriva.org> 1.1-2mdk
- Rebuild

* Fri May 14 2004 <erwan@no.mandrakesoft.com> 1.1-1mdk
- 1.1
- Fixing Url

