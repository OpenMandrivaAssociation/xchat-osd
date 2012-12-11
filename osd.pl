#!/usr/bin/perl -w
# XChat plugin for on-screen display using xosd
# Copyright (C) 2002  Dave O'Neill <dmo@acm.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or (at
# your option) any later version.

# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

## You will need to download the xosd library from http://www.ignavus.net/software.html
## as well as the X::Osd package from http://www.cpan.org/authors/id/G/GO/GOZER/
## This version of osd.pl requires at least X::Osd 0.7

package IRC::Xchat::osd;
use X::Osd;

my $script_name = "osd.pl";
my $script_version = "1.1";

my $is_on = 0;

my $colour = 'gold';
my $delay  = 3;   ## delay in seconds.
my $voffset = 37; ## Vertical offset
my $hoffset = 1;  ## Horizontal offset
my $soffset = 2;  ## Offset for drop shadow
my $osd;

my $handlers = { 
	'on'	=> \&on,
	'off'	=> \&off,
	'delay'		=> \&delay,
	'colour'	=> \&colour,
	'color'		=> \&colour, ## Damn Americans.
	'location'  => \&location,
	'loc'  => \&location,
	'voffset' => \&voffset,
	'hoffset' => \&hoffset,
	'shadow' => \&shadow,
	'test' => \&test,
	'help'	=> \&help,
};

_user_msg("Loaded XChat OSD plugin");
_user_msg("/osd help for more information");
IRC::register ("OSD Script", "0.5", "IRC::Xchat::osd::cleanup", "");
IRC::add_command_handler("osd", "IRC::Xchat::osd::cmd_handler");
IRC::add_message_handler("PRIVMSG", "IRC::Xchat::osd::display_incoming_text");
init();

sub init
{
        $osd = X::Osd->new(1);
        $osd->set_font("-*-helvetica-bold-r-normal-*-*-260-*-*-*-*-iso8859-1");
        $osd->set_colour($colour);
        $osd->set_timeout($delay);
        $osd->set_align(XOSD_top);
        $osd->set_vertical_offset($voffset);
        $osd->set_horizontal_offset($hoffset);
        $osd->set_shadow_offset($soffset);
	on();
	_user_msg("OSD plugin version $script_version now active");
}


sub cmd_handler
{
	my $args = shift;
	$args =~ s/\s+/ /g;
	my ($cmd,@args) = split(/\s/,$args);
	if(exists($handlers->{$cmd})) {
		$handlers->{$cmd}->(@args);
	} else {
		_user_msg("! $cmd is not a valid command.", 0);
	}

	return 1;
}

sub help
{
	_user_msg("Support for xosd in XChat", 0);
	_user_msg("Available commands are: ", 0);
	_user_msg("/osd help", 0);
	_user_msg("    - this command", 0);
	_user_msg("/osd on", 0);
	_user_msg("    - turns on osd support", 0);
	_user_msg("/osd off", 0);
	_user_msg("    - turns off osd support", 0);
	_user_msg("/osd colour <colour>", 0);
	_user_msg("    - Changes colour of text.  <colour> should be a named colour known to X", 0);
	_user_msg("/osd delay <seconds>", 0);
	_user_msg("    - Changes on-screen time of message.  <seconds> should be an integer number of seconds.", 0);
	_user_msg("/osd location (top|bottom)", 0);
	_user_msg("    - Changes location of text on screen", 0);
	_user_msg("/osd voffset <offset>", 0);
	_user_msg("    - Changes the vertical offset of text on screen", 0);
	_user_msg("/osd hoffset <offset>", 0);
	_user_msg("    - Changes the horizontal offset of text on screen", 0);
	_user_msg("/osd shadow <offset>", 0);
	_user_msg("    - Changes the shadow offset of text on screen", 0);
	_user_msg("/osd test <message>", 0);
	_user_msg("    - Write a sample test message using OSD", 0);

}

sub test
{
	my $msg = shift || "OSD: Sample message\n";
	osd($msg);
}

sub on 
{
	if(! $is_on ) {
		$is_on = 1;
		_user_msg("OSD activated.");
	} else {
		_user_msg("OSD already active.");
	}
}

sub off
{
	if($is_on ) {
		_user_msg("OSD deactivated.");
		$is_on = 0;
	} else {
		_user_msg("OSD already deactivated.");
	}
}

sub colour
{
	my $c = shift || do {
		_user_msg("You must supply a colour name.", 0);
		return;
	};
	$colour = $c;
	$osd->set_colour($c);
	_user_msg("Colour has been set to $c");
}

sub voffset
{
	my $d = shift || do {
		_user_msg("You must supply a vertical offset.", 0);
		return;
	};
	$voffset =  $d;
	$osd->set_vertical_offset($d);
	_user_msg("Vertical offset set to $d");
}

sub hoffset
{
	my $d = shift || do {
		_user_msg("You must supply a horizontal offset.", 0);
		return;
	};
	$hoffset =  $d;
	$osd->set_horizontal_offset($d);
	_user_msg("Horizontal offset set to $d");
}

sub shadow
{
	my $d = shift || do {
		_user_msg("You must supply a shadow offset.", 0);
		return;
	};
	$soffset =  $d;
	$osd->set_shadow_offset($d);
	_user_msg("Shadow offset set to $d");
}

sub delay
{
	my $d = shift || do {
		_user_msg("You must supply a delay.");
		return;
	};
	$delay = $d;
	$osd->set_timeout($d);
	_user_msg("Delay timeout set to $d seconds.");
}

sub location
{
	my $loc = shift;
	
	if($loc =~ m/top/i) {
		$osd->set_pos(XOSD_top);
		_user_msg("OSD will now appear at the top of your screen.");
	} elsif($loc =~ m/bot(tom)?/i) {
		$osd->set_pos(XOSD_bottom);
		_user_msg("OSD will now appear at the bottom of your screen.");
	} else {
		_user_msg("You must specify top or bottom.", 0);
	}
}

sub display_incoming_text
{

	my $line = shift(@_);
	if ($is_on)
	{
		my $me = IRC::get_info(1);

		my ($speaker,$addr,$type,$target,$txt) = $line =~ /:(.*?)!(.*?@.*?)\s([^\s]+)\s([^\s]+)\s:(.*)/;
		if($line =~ /\b$me\b/) {
			my $msg = "";
			if($target =~ /^#/) {
				## Said in a channel, so prepend channel name
				$msg .= "$target ";
			}
			if($txt =~ s/ACTION/$speaker/g) {
				
				$msg .= $txt;
			} else {
				## Remove leading name, if present
				$txt =~ s/^\s*$me\s*[:,]?//;
				$msg .= "<$speaker> $txt";
			}
			osd($msg);
		}
	}

	return 0;
}

sub osd
{
	my $msg = shift;
	$osd->string(0,$msg);
}

sub _user_msg
{
	my $msg = shift;
	my $show_using_osd = shift || 1;
	if($is_on && $show_using_osd) {
		osd($msg);
	}
	IRC::print "\0035$msg\003\n";
}

sub cleanup
{
	_user_msg("Unloaded xosd plugin.",0);
}
