## Copyright (C) 2012, 2016, 2020, 2024 Moreno Marzolla
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
##
## @deftypefn {Function File} {[@var{Xl}, @var{Xu}, @var{Rl}, @var{Ru}] =} qncsaba (@var{N}, @var{D})
## @deftypefnx {Function File} {[@var{Xl}, @var{Xu}, @var{Rl}, @var{Ru}] =} qncsaba (@var{N}, @var{S}, @var{V})
## @deftypefnx {Function File} {[@var{Xl}, @var{Xu}, @var{Rl}, @var{Ru}] =} qncsaba (@var{N}, @var{S}, @var{V}, @var{m})
## @deftypefnx {Function File} {[@var{Xl}, @var{Xu}, @var{Rl}, @var{Ru}] =} qncsaba (@var{N}, @var{S}, @var{V}, @var{m}, @var{Z})
##
## @cindex bounds, asymptotic
## @cindex asymptotic bounds
## @cindex closed network, single class
##
## Compute Asymptotic Bounds for the system throughput and response
## time of closed, single-class networks with @math{K} service
## centers.
##
## Single-server and infinite-server nodes are supported.
## Multiple-server nodes and general load-dependent servers are not
## supported.
##
## @strong{INPUTS}
##
## @table @code
##
## @item @var{N}
## number of requests in the system (scalar, @code{@var{N}>0}).
##
## @item @var{D}(k)
## service demand at center @math{k}
## (@code{@var{D}(k) @geq{} 0}).
##
## @item @var{S}(k)
## mean service time at center @math{k}
## (@code{@var{S}(k) @geq{} 0}).
##
## @item @var{V}(k)
## average number of visits to center
## @math{k} (@code{@var{V}(k) @geq{} 0}).
##
## @item @var{m}(k)
## number of servers at center @math{k}
## (if @var{m} is a scalar, all centers have that number of servers). If
## @code{@var{m}(k) < 1}, center @math{k} is a delay center (IS);
## if @code{@var{m}(k) = 1}, center @math{k} is a M/M/1-FCFS server.
## This function does not support multiple-server nodes. Default
## is 1.
##
## @item @var{Z}
## External delay (scalar, @code{@var{Z} @geq{} 0}). Default is 0.
##
## @end table
##
## @strong{OUTPUTS}
##
## @table @code
##
## @item @var{Xl}
## @itemx @var{Xu}
## Lower and upper bounds on the system throughput.
##
## @item @var{Rl}
## @itemx @var{Ru}
## Lower and upper bounds on the system response time.
##
## @end table
##
## @strong{REFERENCES}
##
## @itemize
## @item
## Edward D. Lazowska, John Zahorjan, G.  Scott Graham, and Kenneth
## C. Sevcik, @cite{Quantitative System Performance: Computer System
## Analysis Using Queueing Network Models}, Prentice Hall,
## 1984. @url{http://www.cs.washington.edu/homes/lazowska/qsp/}. In
## particular, see section 5.2 ("Asymptotic Bounds").
## @end itemize
##
## @seealso{qncmaba}
##
## @end deftypefn

## Author: Moreno Marzolla <moreno.marzolla(at)unibo.it>
## Web: http://www.moreno.marzolla.name/

function [Xl Xu Rl Ru] = qncsaba( varargin ) #N, S, V, m, Z )

  if (nargin<2 || nargin>5)
    print_usage();
  endif

  [err N S V m Z] = qncschkparam( varargin{:} );
  isempty(err) || error(err);

  all(m<=1) || ...
      error( "multiple server nodes are not supported" );

  D = S.*V;

  Dtot_single = sum(D(m==1)); # total demand at single-server nodes
  Dtot_delay = sum(D(m<1)); # total demand at IS nodes
  Dtot = sum(D); # total demand
  Dmax = max(D); # max demand

  Xl = N/(N*Dtot_single + Dtot_delay + Z);
  Xu = min( N/(Dtot+Z), 1/Dmax );
  Rl = max( Dtot, N*Dmax - Z );
  Ru = N*Dtot_single + Dtot_delay;
endfunction

%!test
%! fail("qncsaba(-1,0)", "N must be");
%! fail("qncsaba(1,[])", "nonempty");
%! fail("qncsaba(1,[-1 2])", "nonnegative");
%! fail("qncsaba(1,[1 2],[1 2 3])", "incompatible size");
%! fail("qncsaba(1,[1 2 3],[1 2 -1])", "nonnegative");
%! fail("qncsaba(1,[1 2 3],[1 2 3],[1 2])", "incompatible size");
%! fail("qncsaba(1,[1 2 3],[1 2 3],[1 2 1])", "not supported");
%! fail("qncsaba(1,[1 2 3],[1 2 3],[1 1 1],-1)", "nonnegative");
%! fail("qncsaba(1,[1 2 3],[1 2 3],1,[0 0])", "scalar");

## Example 9.6 p. 913 Bolch et al.
%!test
%! N = 20;
%! S = [ 4.6*2 8 ];
%! Z = 120;
%! [X_l X_u R_l R_u] = qncsaba(N, S, ones(size(S)), ones(size(S)), Z);
%! assert( [X_u R_l], [0.109 64], 1e-3 );

%!test
%! S = [1 0.8 1.2 0.5];
%! V = [1 2 2 1];
%! D = S .* V;
%! N = 50;
%! tol = 1e-7; # compensate for numerical inaccuracies
%! for n=1:N
%!   [U R Q X] = qncsmva(n, S, V);
%!   Xs = X(1)/V(1);
%!   Rs = dot(R,V);
%!   [Xl Xu Rl Ru] = qncsaba( n, D );
%!   assert( Xl <= Xs+tol );
%!   assert( Xu >= Xs-tol );
%!   assert( Rl <= Rs+tol );
%!   assert( Ru >= Rs-tol );
%! endfor

%!demo
%! S = [10 7 5 4];
%! NN = 50;
%! Xl = Xu = Xmva = zeros(1,NN);
%! for n=1:NN
%!   [Xl(n) Xu(n)] = qncsaba(n,S);
%!   [na na na X] = qncsmva(n,S,ones(size(S)));
%!   Xmva(n) = X(1);
%! endfor
%! plot(1:NN, Xl, ":b", "linewidth", 2, ...
%!      1:NN, Xu, ":b;ABA;", "linewidth", 2, ...
%!      1:NN, Xmva, "k;MVA;", "linewidth", 2);
%! xlabel("N. of requests");
%! ylim([0, 0.15]);
%! title("System throughput"); legend("boxoff");
%! legend("location", "northeast");
