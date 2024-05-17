## Copyright (C) 2024 Moreno Marzolla
##
## This file is part of the queueing toolbox.
##
## The queueing toolbox is free software: you can redistribute it and/or
## modify it under the terms of the GNU General Public License as
## published by the Free Software Foundation, either version 3 of the
## License, or (at your option) any later version.
##
## The queueing toolbox is distributed in the hope that it will be
## useful, but WITHOUT ANY WARRANTY; without even the implied warranty
## of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with the queueing toolbox. If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn  {} {} markocvhains_figures ()
##
## The `markovchains_figures.m` file is inside the `doc/` directory,
## and is used to generate images used in the manual.
##
## @end deftypefn

1; # not a function file

demo("dtmcmtta", 1); # snakes and ladders
print("snakes_and_ladders.eps", "-depsc2", "-tight");

demo("ctmcexps", 1);
print("ctmcexps_1.eps", "-depsc2", "-tight");
