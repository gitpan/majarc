#!/usr/local/bin/perl
#       $Id: majarc.pl,v 1.4 1999/01/10 00:28:51 cinar Exp cinar $
#
# Majarc.pl: Create Monthly Archives of your Majordomo Lists
#
# This file and all associated files and documentation:
# 	Copyright (C) 1998,1999 Ali Onur Cinar <root@zdo.com>
#
# Latest version can be downloaded from:
#
#   ftp://hun.ece.drexel.edu/pub/cinar/majarc*
#   ftp://ftp.cpan.org/pub/CPAN/authors/id/A/AO/AOCINAR/majarc*
#   ftp://sunsite.unc.edu/pub/Linux/system/mail/misc/majarc*
#  http://artemis.efes.net/cinar/majarc
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version. And also
# please DO NOT REMOVE my name, and give me a CREDIT when you use
# whole or a part of this program in an other program.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
# $Log: majarc.pl,v $
# Revision 1.4  1999/01/10 00:28:51  cinar
# bug correction
#
# Revision 1.1  1999/01/09 23:40:55  cinar
# Initial revision
#

require "getopts.pl";

$verraw  = '$Revision: 1.4 $'; $verraw =~ /.{11}(.{4})/g; $majarcver = "1.$1";

@help_msg = (
        "\nMajarc.pl v$majarcver [$^O] (c) '98-99 by Ali Onur Cinar <root\@zdo.com>\n",
        "This program is free software; you can redistribute it and/or modify it under\n",
        "the terms of the GNU General Public License as published by the Free Software\n",
        "Foundation; either version 2 of the License, or any later version.\n\n",
        "Usage: majarc [options] \n\n",
        "Options:\n",
        "       -a -A             Archive target directory (ex: /home/ftp/lists)\n",
        "       -f -F             Archive name (ex: perl)\n\n",
	"       -h -H             This help screen\n\n");

if(!&Getopts("a:A:f:F:hH") || $opt_h || $opt_H || (!$opt_a && !$opt_A) || (!$opt_f && !$opt_F)) { print @help_msg; exit; }

undef @help_msg;

# default compression program
	$c_archiver = "zip -9";		# compressor
	$u_archiver = "unzip";		# un compressor
	$ext_archiver = "zip";		# compressor's extension

# env. path should be complete, so
	$old_env_path = $ENV{PATH};
	$ENV{PATH} = "$ENV{PATH}:/bin:/usr/bin:/usr/local/bin";

# where we are now
	$old_pwd = `pwd`;

# defining the main vars.
	$arcdir = $opt_a || $opt_A;
	$arcid = $opt_f || $opt_F;

# main
	@message = <STDIN>;		# buffering message
	chdir $arcdir;

	$current_date = `date`;
	@date_ary = split(' ',$current_date);

	$arcfile = sprintf("%s-%s-%s",$arcid,$date_ary[1],$date_ary[5]);

	system (sprintf("%s %s.%s > /dev/null",$u_archiver,$arcfile,$ext_archiver));
	system (sprintf("rm %s.%s",$arcfile,$ext_archiver));

	open ARCF, ">>$arcfile";

		print ARCF "\n==[separator]==\n";
		print ARCF @message;

	close ARCF;

	system (sprintf("%s %s.%s %s > /dev/null",$c_archiver,$arcfile,$ext_archiver,$arcfile));
	system ("rm $arcfile");

	chdir $old_pwd;
	$ENV{PATH} = $old_env_path;
	
