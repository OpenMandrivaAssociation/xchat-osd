%define name xchat-osd
%define version 1.1
%define release %mkrel 4

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
