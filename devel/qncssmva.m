## Copyright (C) 2020 Moreno Marzolla
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
## @deftypefn {Function File} {[@var{U}, @var{R}, @var{Q}, @var{X}] =} qncssmva (@var{N}, @var{S}, @var{V})
## @deftypefnx {Function File} {[@var{U}, @var{R}, @var{Q}, @var{X}] =} qncssmva (@var{N}, @var{S}, @var{V}, @var{Z})
##
## @cindex Mean Value Analysys (MVA)
## @cindex SMVA
## @cindex closed network, single class
## @cindex load-dependent service center
##
## Stable MVA (SMVA) approximate algorithm for closed, single class
## queueing networks with @math{K} service centers and load-dependent
## service times. This function supports FCFS, LCFS-PR, PS and IS
## nodes. For networks with only fixed-rate centers and
## multiple-server nodes, the function @code{qncsmva} is more
## efficient.
##
## @strong{INPUTS}
##
## @table @code
##
## @item @var{N}
## Population size (number of requests in the system, @code{@var{N} @geq{} 0}).
## If @code{@var{N} == 0}, this function returns @code{@var{U} = @var{R} = @var{Q} = @var{X} = 0}
##
## @item @var{S}(k,n)
## mean service time at center @math{k} where there are @math{n}
## requests, @math{1 @leq{} n @leq{} N}. @code{@var{S}(k,n)} @math{= 1
## / \mu_{k}(n)}, where @math{\mu_{k}(n)} is the service rate of
## center @math{k} when there are @math{n} requests.
##
## @item @var{V}(k)
## average number of visits to service center @math{k} (@code{@var{V}(k) @geq{} 0}).
##
## @item @var{Z}
## external delay ("think time", @code{@var{Z} @geq{} 0}); default 0.
##
## @end table
##
## @strong{OUTPUTS}
##
## @table @code
##
## @item @var{U}(k)
## utilization of service center @math{k}. The
## utilization is defined as the probability that service center
## @math{k} is not empty, that is, @math{U_k = 1-\pi_k(0)} where
## @math{\pi_k(0)} is the steady-state probability that there are 0
## jobs at service center @math{k}.
##
## @item @var{R}(k)
## response time on service center @math{k}.
##
## @item @var{Q}(k)
## average number of requests in service center @math{k}.
##
## @item @var{X}(k)
## throughput of service center @math{k}.
##
## @end table
##
## @strong{REFERENCES}
##
## @itemize
## @item
## Lei Zhang and Douglas G. Down, @cite{SMVA: A Stable Mean Value Analysis Algorithm for Closed Systems with Load-dependent Queues}. In: Puliafito A., Trivedi K. (eds) Systems Modeling: Methodologies and Tools. EAI/Springer Innovations in Communication and Computing. Springer, Cham, 2018, ISBN 978-3-319-92377-2
## @uref{https://doi.org/10.1007/978-3-319-92378-9_2}
## @end itemize
##
## @seealso{qncssmva}
## 
## @end deftypefn

## Author: Moreno Marzolla <moreno.marzolla(at)unibo.it>
## Web: http://www.moreno.marzolla.name/

function [U R Q X] = qncssmva( N, S, V, Z )

  if ( nargin < 3 || nargin > 4 ) 
    print_usage();
  endif

  isvector(V) && all(V>=0) || ...
      error( "V must be a vector >= 0" );
  V = V(:)'; # make V a row vector
  K = length(V); # Number of servers
  isscalar(N) && N >= 0 || ...
      error( "N must be >= 0" );
  ( ismatrix(S) && rows(S) == K && columns(S) >= N ) || ...
      error( "S size mismatch: is %dx%d, should be %dx%d", rows(S), columns(S), K, N );
  all(S(:)>=0) || ...
      error( "S must be >= 0" );

  if ( nargin < 4 ) 
    Z = 0;
  else
    isscalar(Z) && Z>=0 || ...
        error( "Z must be >= 0" );
  endif

  if (N == 0) # trivial case first
    U = R = Q = X = 0*V;
    return; 
  endif
  
  ## The reference paper uses m as the number of servers; to make this
  ## code easier to understand, we adopt the same notation.
  M = K;

  S = S(1:M, 1:N);
  D = repmat(V',1,N) .* S; # D(m,n) is the service demand at center m if there are n requests

  for m=1:M
    #assert( all(m*D(m,1:(N-1)) >= D(m,N) ) );
  endfor

  Qa = Qe = Qo = zeros(M,N +1); # Qa(m,n +1) is Q^a_m(n) in the paper; same for Qe and Qo
  Dq = zeros(1, N);
  Dd = zeros(M, N);
  Xs = zeros(1, N); # System throughput
  Rq = Rd = zeros(M, N);
  
  for m=1:M
    for n=1:N
      Dq(m) = D(m,N);
      if (n<N)
        Dd(m,n) = n*D(m,n) - D(m,N);
      else
        Dd(m,n) = (N-1)*D(m,N);        
      endif
      assert( Dq(m) >= 0 );
      assert( Dd(m,n) >= 0 );
    endfor
  endfor
  assert(all(Dq(:) >= 0));
  assert(all(Dd(:) >= 0));
  for n=1:N
    for m=1:M
      if (n==1)
        Qe(m,n +1) = 1;
      else
        Qe(m,n +1) = n/(n-1) * Qo(m,n-1 +1);
      endif
      assert(ceil(Qe(m, n +1)) <= N);
      Rq(m,n) = Dq(m) * (1 + Qa(m,n-1 +1));
      Rd(m,n) = Dd(m, ceil(Qe(m,n +1)));
    endfor
    Xs(n) = n / (Z + sum(Rq(:,n) + Rd(:,n)));
    for m=1:M
      Qa(m,n +1) = Xs(n) * Rq(m,n);
      Qo(m,n +1) = Xs(n) * (Rq(m,n) + Rd(m,n));
    endfor
  endfor
  # R = sum(Rq(:,N) + Rd(:, N)); # system throughput
  R = (Rq(:,N) + Rd(:,N))' ./ V; # Response times changed wrt the original paper
                                 # Q = Qo(:, N +1)';
  Q = Xs(N) * (Rq(:,N) .+ Rd(:,N))';
  X = Xs(N) * V;
  U = NA;
endfunction

## Check degenerate case of N==0 (general LD case)
%!test
%! N = 0;
%! S = [1 2; 3 4; 5 6; 7 8];
%! V = [1 1 1 4];
%! [U R Q X] = qncssmva(N, S, V);
%! assert( U, 0*V );
%! assert( R, 0*V );
%! assert( Q, 0*V );
%! assert( X, 0*V );

%!test
%! # Exsample 3.42 p. 577 Jain
%! V = [ 16 10 5 ];
%! N = 20;
%! S = [ 0.125 0.3 0.2 ];
%! Sld = repmat( S', 1, N );
%! Z = 4;
%! [U1 R1 Q1 X1] = qncssmva(N,Sld,V,Z);
%! [U2 R2 Q2 X2] = qncsmva(N,S,V,ones(1,3),Z);
%! assert( R1, R2, 1e-3 );
%! assert( Q1, Q2, 1e-3 );
%! assert( X1, X2, 1e-3 );

%!test
%! # Example 8.7 p. 349 Bolch et al.
%! N = 3;
%! Sld = 1 ./ [ 2     4     4; ...
%!              1.667 1.667 1.667; ...
%!              1.25  1.25  1.25; ...
%!              1     2     3 ];
%! V = [ 1 .5 .5 1 ];
%! [U R Q X] = qncssmva(N, Sld, V);
%! assert( Q, [0.624 0.473 0.686 1.217], 1e-3 );
%! assert( R, [0.512 0.776 1.127 1], 1e-3 );

%!test
%! # Example 8.4 p. 333 Bolch et al.
%! N = 3;
%! S = [ .5 .6 .8 1 ];
%! m = [2 1 1 N];
%! Sld = zeros(3,N);
%! Sld(1,:) = .5 ./ [1 2 2];
%! Sld(2,:) = [.6 .6 .6];
%! Sld(3,:) = [.8 .8 .8];
%! Sld(4,:) = 1 ./ [1 2 3];
%! V = [ 1 .5 .5 1 ];
%! [U1 R1 Q1 X1] = qncssmva(N,Sld,V);
%! [U2 R2 Q2 X2] = qncsmva(N,S,V,m);
%! ## Note that qncssmva computes the utilization in a different
%! ## way as qncsmva; indeed, qncsmva knows that service
%! ## center i has m(i)>1 servers, but qncssmva does not. Thus,
%! ## utilizations for multiple-server nodes cannot be compared
%! ## directly.
%! #assert( U1([2,3]), U2([2,3]), 1e-3 );
%! assert( R1, R2, 1e-3 );
%! assert( Q1, Q2, 1e-3 );
%! assert( X1, X2, 1e-3 );

