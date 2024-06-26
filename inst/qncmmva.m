## Copyright (C) 2008, 2009, 2010, 2011, 2012, 2013, 2016, 2018, 2020, 2022 Moreno Marzolla
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
## @deftypefn {Function File} {[@var{U}, @var{R}, @var{Q}, @var{X}] =} qncmmva (@var{N}, @var{S} )
## @deftypefnx {Function File} {[@var{U}, @var{R}, @var{Q}, @var{X}] =} qncmmva (@var{N}, @var{S}, @var{V})
## @deftypefnx {Function File} {[@var{U}, @var{R}, @var{Q}, @var{X}] =} qncmmva (@var{N}, @var{S}, @var{V}, @var{m})
## @deftypefnx {Function File} {[@var{U}, @var{R}, @var{Q}, @var{X}] =} qncmmva (@var{N}, @var{S}, @var{V}, @var{m}, @var{Z})
## @deftypefnx {Function File} {[@var{U}, @var{R}, @var{Q}, @var{X}] =} qncmmva (@var{N}, @var{S}, @var{P})
## @deftypefnx {Function File} {[@var{U}, @var{R}, @var{Q}, @var{X}] =} qncmmva (@var{N}, @var{S}, @var{P}, @var{r})
## @deftypefnx {Function File} {[@var{U}, @var{R}, @var{Q}, @var{X}] =} qncmmva (@var{N}, @var{S}, @var{P}, @var{r}, @var{m})
##
## @cindex Mean Value Analysys (MVA)
## @cindex closed network, multiple classes
## @cindex multiclass network, closed
##
## Compute steady-state performance measures for closed, multiclass
## queueing networks using the Mean Value Analysys (MVA) algorithm.
##
## Queueing policies at service centers can be any of the following:
##
## @table @strong
##
## @item FCFS
## (First-Come-First-Served) customers are served in order of arrival;
## multiple servers are allowed. For this kind of queueing discipline,
## average service times must be class-independent.
##
## @item PS
## (Processor Sharing) customers are served in parallel by a single
## server, each customer receiving an equal share of the service rate.
##
## @item LCFS-PR
## (Last-Come-First-Served, Preemptive Resume) customers are served in
## reverse order of arrival by a single server and the last arrival
## preempts the customer in service who will later resume service at the
## point of interruption.
##
## @item IS
## (Infinite Server) customers are delayed independently of other
## customers at the service center (there is effectively an infinite
## number of servers).
##
## @end table
##
## @strong{INPUTS}
##
## @table @code
##
## @item @var{N}(c)
## number of class @math{c} requests; @code{@var{N}(c) @geq{} 0}. If
## class @math{c} has no requests (@code{@var{N}(c) == 0}), then for
## all @var{k}, this function returns
## @code{@var{U}(c,k) = @var{R}(c,k) = @var{Q}(c,k) = @var{X}(c,k) = 0}
##
## @item @var{S}(c,k)
## mean service time for class @math{c} requests at center @math{k}
## (@code{@var{S}(c,k) @geq{} 0}). If the service time at center
## @math{k} is class-dependent, then center @math{k} is assumed
## to be of type @math{-/G/1}--PS (Processor Sharing). If center
## @math{k} is a FCFS node (@code{@var{m}(k)>1}), then the service
## times @strong{must} be class-independent, i.e., all classes
## @strong{must} have the same service time.
##
## @item @var{V}(c,k)
## average number of visits of class @math{c} requests at
## center @math{k}; @code{@var{V}(c,k) @geq{} 0}, default is 1.
## @strong{If you pass this argument, class switching is not allowed}
##
## @item @var{P}(r,i,s,j)
## probability that a class @math{r} request completing service at center
## @math{i} is routed to center @math{j} as a class @math{s} request; the
## reference stations for each class are specified with the paramter
## @var{r}. @strong{If you pass argument @var{P}, class switching is
## allowed}; however, you can not specify any external delay (i.e.,
## @var{Z} must be zero) and all servers must be fixed-rate or
## infinite-server nodes (@code{@var{m}(k) @leq{} 1} for all
## @math{k}).
##
## @item @var{r}(c)
## reference station for class @math{c}. If omitted, station 1 is the
## reference station for all classes. See @command{qncmvisits}.
##
## @item @var{m}(k)
## If @code{@var{m}(k)<1}, then center @math{k} is assumed to be a delay
## center (IS node @math{-/G/\infty}). If @code{@var{m}(k)==1}, then
## service center @math{k} is a regular queueing center
## (@math{M/M/1}--FCFS, @math{-/G/1}--LCFS-PR or @math{-/G/1}--PS).
## Finally, if @code{@var{m}(k)>1}, center @math{k} is a
## @math{M/M/m}--FCFS center with @code{@var{m}(k)} identical servers.
## Default is @code{@var{m}(k)=1} for each @math{k}.
##
## @item @var{Z}(c)
## class @math{c} external delay (think time); @code{@var{Z}(c) @geq{}
## 0}. Default is 0. This parameter can not be used if you pass a
## routing matrix as the second parameter of @code{qncmmva}.
##
## @end table
##
## @strong{OUTPUTS}
##
## @table @code
##
## @item @var{U}(c,k)
## If @math{k} is a FCFS, LCFS-PR or PS node (@code{@var{m}(k) @geq{}
## 1}), then @code{@var{U}(c,k)} is the class @math{c} utilization at
## center @math{k}, @math{0 @leq{} U(c,k) @leq{} 1}. If @math{k} is an
## IS node, then @code{@var{U}(c,k)} is the class @math{c} @emph{traffic
## intensity} at center @math{k}, defined as @code{@var{U}(c,k) =
## @var{X}(c,k)*@var{S}(c,k)}. In this case the value of
## @code{@var{U}(c,k)} may be greater than one.
##
## @item @var{R}(c,k)
## class @math{c} response time at center @math{k}. The class @math{c}
## @emph{residence time} at center @math{k} is @code{@var{R}(c,k) *
## @var{C}(c,k)}. The total class @math{c} system response time is
## @code{dot(@var{R}, @var{V}, 2)}.
##
## @item @var{Q}(c,k)
## average number of class @math{c} requests at center @math{k}. The
## total number of requests at center @math{k} is
## @code{sum(@var{Q}(:,k))}. The total number of class @math{c}
## requests in the system is @code{sum(@var{Q}(c,:))}.
##
## @item @var{X}(c,k)
## class @math{c} throughput at center @math{k}. The class @math{c}
## throughput can be computed as @code{@var{X}(c,1) / @var{V}(c,1)}.
##
## @end table
##
## @strong{NOTES}
##
## If the function call specifies the visit ratios @var{V}, then class
## switching is @strong{not} allowed. If the function call specifies
## the routing probability matrix @var{P}, then class switching
## @strong{is} allowed; however, in this case all nodes are restricted
## to be fixed rate servers or delay centers: multiple-server and
## general load-dependent centers are not supported.
##
## In presence of load-dependent servers (e.g., if @code{@var{m}(i)>1}
## for some @math{i}), the MVA algorithm is known to be numerically
## unstable. Generally this problem shows up as negative values for the
## computed response times or utilizations. This is not a problem with the
## @code{queueing} package, but with the MVA algorithm;
## as such, there is no known workaround at the moment (aoart from using a
## different solution technique, if available). This function prints a
## warning if it detects numerical problems; you can disable the warning
## with the command @code{warning("off", "qn:numerical-instability")}.
##
## Given a network with @math{K} service centers, @math{C} job classes
## and population vector @math{{\bf N}=\left[N_1, @dots{}, N_C\right]}, the MVA
## algorithm requires space @math{O(C \prod_i (N_i + 1))}. The time
## complexity is @math{O(CK\prod_i (N_i + 1))}. This implementation is
## slightly more space-efficient (see details in the code). While the
## space requirement can be mitigated by using some optimizations, the
## time complexity can not. If you need to analyze large closed networks
## you should consider the @command{qncmmvaap} function, which implements
## the approximate MVA algorithm. Note however that @command{qncmmvaap}
## will only provide approximate results.
##
## @strong{REFERENCES}
##
## @itemize
## @item
## M. Reiser and S. S. Lavenberg, @cite{Mean-Value Analysis of Closed
## Multichain Queuing Networks}, Journal of the ACM, vol. 27, n. 2, April
## 1980, pp. 313--322. @uref{http://doi.acm.org/10.1145/322186.322195, 10.1145/322186.322195}
## @end itemize
##
## This implementation is based on G. Bolch, S. Greiner, H. de Meer and
## K. Trivedi, @cite{Queueing Networks and Markov Chains: Modeling and
## Performance Evaluation with Computer Science Applications}, Wiley,
## 1998 and Edward D. Lazowska, John Zahorjan, G. Scott Graham, and
## Kenneth C. Sevcik, @cite{Quantitative System Performance: Computer
## System Analysis Using Queueing Network Models}, Prentice Hall,
## 1984. @url{http://www.cs.washington.edu/homes/lazowska/qsp/}. In
## particular, see section 7.4.2.1 ("Exact Solution Techniques").
##
## @seealso{qnclosed, qncmmvaapprox, qncmvisits}
##
## @end deftypefn

## Author: Moreno Marzolla <moreno.marzolla(at)unibo.it>
## Web: http://www.moreno.marzolla.name/

function [U R Q X] = qncmmva( varargin )

  if ( nargin < 2 || nargin > 5 )
    print_usage();
  endif

  if ( nargin == 2 || ndims(varargin{3}) == 2 )
    [err N S V m Z] = qncmchkparam( varargin{:} );
    isempty(err) || error(err);
    [U R Q X] = __qncmmva_nocs( N, S, V, m, Z );
  else
    [U R Q X] = __qncmmva_cs( varargin{:} );
  endif

endfunction

##############################################################################
## Analyze closed, multiclass QNs with class switching
function [U R Q X] = __qncmmva_cs( N, S, P, r, m )

  if ( nargin < 3 || nargin > 5 )
    print_usage();
  endif

  isvector(N) && all( N>=0 ) || ...
      error( "N must be >=0" );
  N = N(:)'; # make N a row vector
  C = length(N); ## Number of classes
  ( ndims(S) == 2 ) || ...
      error( "S must be a matrix" );
  K = columns(S); ## Number of service centers
  size(S) == [C,K] || ...
      error( "S size mismatch (is %dx%d, should be %dx%d)", rows(S), columns(S), C, K );
  ndims(P) == 4 && size(P) == [C,K,C,K] || ...
      error( "P size mismatch (should be %dx%dx%dx%d)",C,K,C,K );

  if ( nargin < 4 )
    r = ones(1,C); # reference station
  else

    if (isscalar(r))
      r = r*ones(1,C);
    endif

    ( isvector(r) && length(r) == C ) || ...
	error("r must be a vector with %d elements", C);
    r = r(:)';
    all( r>=1 && r<=K ) || ...
	error("elements of r are out of range [1,%d]",K);
  endif

  if ( nargin < 5 )
    m = ones(1,K);
  else
    isvector(m) || ...
        error( "m must be a vector" );
    m = m(:)'; # make m a row vector
    length(m) == K || ...
        error( "m size mismatch (should be %d, is %d)", K, length(m) );
  endif

  ## Check consistency of parameters
  all(S(:) >= 0) || ...
      error( "S must be >= 0" );
  all( any(S>0,2) ) || ...
      error( "S must contain at least a value >0 for each row" );
  all(P(:)>= 0) || ...
      error( "P must be >=0" );

  U = R = Q = X = zeros(C,K);

  ## 1. Compute visit counts
  [V ch] = qncmvisits(P,r);

  ## 2. Identify chains
  nch = max(ch);

  ## 3. Compute visit counts for the equivalent network
  Vstar = zeros(nch,K);
  for q=1:nch
    r = (ch == q);
    Vstar(q,:) = sum(V(r,:),1);
  endfor

  ## 4. Compute proportionality constants
  alpha = zeros(C,K);
  for r=1:C
    for k=find( Vstar(ch(r),:) > 0 )
      alpha(r,k) = V(r,k) / Vstar( ch(r), k );
    endfor
  endfor

  ## 5. Compute service times
  Sstar = zeros(nch,K);
  for q=1:nch
    r = (ch==q);
    Sstar(q,:) = dot( alpha(r,:), S(r,:), 1 );
  endfor

  ## 6. Compute populations of superclasses
  Nstar = zeros(1,nch);
  for q=1:nch
    r = (ch == q);
    Nstar(q) = sum( N(r) );
  endfor

  ## 7. Solve the equivalent network
  [Ustar Rstar Qstar Xstar Qnm1] = __qncmmva_nocs( Nstar, Sstar, Vstar, m, zeros(size(Nstar)) );

  ## 8. Compute solutions of the original network
  for r=1:C
    for k=1:K
      R(r,k) = S(r,k) * (1 + Qnm1(ch(r),k)*(m(k)==1));
      X(r,k) = alpha(r,k) * Xstar(ch(r),k);
      Q(r,k) = X(r,k) * R(r,k);
      U(r,k) = S(r,k) * X(r,k) / max(1,m(k));
    endfor
  endfor

  ## 9. Check for numerical instability
  if ( any(U(:)<0) || any(R(:)<0) )
    warning("qn:numerical-instability",
	    "Numerical instability detected. Type 'help qncmmva' for details");
  endif

endfunction

##############################################################################
## Analyze closed, multiclass QNs WITHOUT class switching
##
## This implementation is based on:
##
## Herb Schwetman, "Implementing the Mean Value Algorithm for the
## Solution of Queueing Network Models", technical report OSD-TR-355,
## dept. of Computer Science, Purdue University, feb. 1982.
##
function [U R Q X Qnm1] = __qncmmva_nocs( N, S, V, m, Z )

  assert( nargin == 5 );

  all( any(S>0,2) ) || ...
      error( "S must contain at least a value >0 for each row" );

  [C K] = size(S);

  ## ensure that the service times for multiserver nodes
  ## are class-independent
  for k=find(m>1)
    all( S(:,k) == S(1,k) ) || ...
        error( "Service times for FCFS node %d are not class-independent", k );
  endfor

  ## Initialize results
  R = zeros( C, K );
  X = zeros( 1, C );
  D = S .* V;

  ## The multiclass MVA algorithm requires to store the queue lengths Q(
  ## _n_, k ) at center k where the population vector is _n_. The space
  ## required would be K*prod(N+1), but this can be reduced by
  ## considering that, at each iteration of the main MVA loop, the total
  ## number of requests is n; therefore it is sufficient to consider the
  ## first (C-1) components of vector _n_ to uniquely identify the cell
  ## containing Q( _n_, k ). See Schwetman for a better explanation.
  bufsize = prod((N+1)(1:end-1));
  Q_next = Q = zeros( bufsize,K );

  p = cell(1,K);
  for k=find(m>1)
    ## p{i}(j+1,k+1) is the probability to have j jobs at node i
    ## where the network is in state k
    p{k} = zeros( m(k)+1,bufsize );
    p{k}(1,__getidx(N,0*N)) = 1;
  endfor

  Qnm1= zeros(C,K); ## Qnm1(c,k) is the number of requests in center k, provided that the population size is N-1_c (N is the total population vector). This value is needed by __qncmmva_cs. Qnm1 is only filled for M/M/1 or PS centers. The values are not computed for PS nodes

  dd = zeros(1,C);
  for c=find(N>0)
    h = zeros(1,C); h(c) = 1;
    dd(c) = __getidx(N,h)-1;
  endfor

  for n=1:sum(N)

    ## MVA iteration for population size n
    n_bar = zeros(1, C);

    const = min(n, N);
    mp = 0;
    while ( all(n_bar(C) <= const(C)) )

      ## Fill the current configuration (algorithm 3b, p. 10, Schwetman)
      x=n-mp;
      i=1;
      while ( x>0 && i<=C )
	n_bar(i) = min(x,const(i));
	x -= n_bar(i);
	mp += n_bar(i);
	i += 1;
      endwhile

      idx = __getidx( N, n_bar );

      R = S;

      ## Compute response time for LI servers
      k=find(m==1);
      for c=find(n_bar>0)
	## idx-dd(c) is the index of element n_bar - 1_c
        R(c,k) = S(c,k).*(1 + Q( idx-dd(c), k ) );
        Qnm1(c,k) = Q( idx-dd(c), k);
        ## for FCFS nodes with class-dependent service times,
        ## it is possible to use the following approximation
        ## (p. 469 Bolch et al.)
        ##
        ## R(c,k) = S(c,k) + sum( S(:,k) * Q(idx(:), k) );
	## R(c,k) = S(c,k) + sum( S(:,k) .* Q(idx, k) .* V(:,k) ) / sum(V(:,k));
      endfor

      ## Compute response time for LD servers
      for k=find(m>1)
        j=0:m(k)-2; # range
	for c=find(n_bar > 0 )
          R(c,k) = S(c,k)/m(k)*(1 + Q( idx-dd(c), k ) + ...
                                dot(m(k)-j-1,p{k}(j+1,idx-dd(c)) ) );
	endfor
      endfor

      X = n_bar ./ ( Z + dot(R,V,2)' ); # X(c) = N(c) / ( Z(c) + sum_k R(c,k) * V(c,k) )

      ## Q_k = sum_c X(c) * R(c,k) * V(c,k)
      Q_next( idx, : ) = (X * (R .* V))';

      ## Update marginal probabilities for LD servers
      for k=find(m>1)
        j = 1:m(k)-1;
	s = zeros(size(j));
        for r=find(n_bar>0)
          s+=(D(r,k)*X(r)*p{k}(j,idx-dd(r)))';
        endfor
        p{k}(j+1,idx) = s./j;
        p{k}(1,idx) = 1-1/m(k)*(dot( D(:,k),X ) + ...
                                dot( m(k)-j, p{k}(j+1,idx) ) );
      endfor
#{
      ## The following "if" is in the paper, but it makes the algorithm
      ## incorrect. Therefore, it is commented out.

      if ( n_bar(C) == N(C) )
	break;
      endif
#}

      ## Advance to next feasible configuration (Algorithm 3c, p. 10 Schwetman)
      i = 1;
      sw = true;
      while sw
	if ( ( mp==n || n_bar(i)==const(i)) && ( i<C ) )
          mp -= n_bar(i);
          n_bar(i) = 0;
          i += 1;
	else
          n_bar(i)=n_bar(i)+1;
          mp += 1;
          sw = false;
	endif
      endwhile
    endwhile

    Q = Q_next;
  endfor
  U = diag(X)*D ./ max(1,repmat(m,C,1)); # U(c,k) = X(c)*D(c,k)
  Q = diag(X)*(R.*V);
  X = diag(X)*V;

  ## Check for numerical instability
  if ( any(U(:)<0) || any(R(:)<0) )
    warning("qn:numerical-instability",
	    "Numerical instability detected. Type 'help qncmmva' for details");
  endif

endfunction

##############################################################################
## Compute the linear index corresponding to vector i from a population
## of N.
function idx = __getidx( N, i )
  if ( length(N) == 1 )
    idx = 1;
  else
    i_cell = num2cell( (i+1)(1:end-1) );
    idx = sub2ind( (N+1)(1:end-1), i_cell{:} );
  endif
endfunction

%!test
%! S = [1 1 2; 1 1 1];
%! V = [1 1 1; 1 1 1];
%! N = [1 1];
%! m = [1 1 2];
%! fail( "qncmmva(N)" );
%! fail( "qncmmva(N,S,V,m)", "independent" );
%! S = [0 0 0; 1 1 1];
%! fail( "qncmmva(N,S,V,m)", "must contain at least" );
%! S = [1 2 3; 1 2 3];
%! N = [1 1];
%! V = zeros(3,2,3);
%! fail( "qncmmva(N,S,V)", "size mismatch" );
%! fail( "qncmmva([0.3 1], [1 2; 3 4])", "integer");
%! fail( "qncmmva([-1 0], [1 2; 3 4])", "nonnegative");

## Check degenerate case (population is zero); LI servers
%!test
%! S = [1 1 1; 1 1 1];
%! N = [0 0];
%! [U R Q X] = qncmmva(N, S);
%! assert( U, 0*S );
%! assert( R, 0*S );
%! assert( Q, 0*S );
%! assert( X, 0*S );

## Check degenerate case (population is zero); LD servers
%!test
%! S = [1 1 1; 1 1 1];
%! V = [1 1 1; 1 1 1];
%! N = [0 0];
%! m = [2 2 2];
%! [U R Q X] = qncmmva(N, S, V, m);
%! assert( U, 0*S );
%! assert( R, 0*S );
%! assert( Q, 0*S );
%! assert( X, 0*S );

## Example p. 142, Lazowska et al., "Quantitative System Performance:
## Computer System Analysis Using Queueing Network Models"
%!test
%! S = [ 1/10 1/3; 2/5 1 ];
%! V = [ 10 9; 5 4 ];
%! N = [ 1 1 ];
%! [U R Q X] = qncmmva(N,S,V);
%! assert( Q, [ 4/19 15/19; 5/19 14/19 ], 1e-3 );
%! assert( R .* V, [ 4/3 5; 5/2 7 ], 1e-3 );
%! assert( diag( X ./ V )', [ 3/19 2/19 ], 1e-3 );
%! assert( all(U(:)<=1) );
%! assert( Q, R.*X, 1e-5 ); # Little's Law

## Example 8.3 p. 331, Bolch et al. Note that this is not a multiclass
## network, because there is a single job class. Nevertheless, the
## multiclass MVA algorithm must produce the same results as the single
## class one.
%!test
%! S = [0.02 0.2 0.4 0.6];
%! V = [1 0.4 0.2 0.1];
%! N = [6];
%! [U R Q X] = qncmmva( N, S, V );
%! assert( Q, [0.244 2.261 2.261 1.234], 1e-3 );
%! assert( R, [0.025 0.570 1.140 1.244], 1e-3 );
%! assert( X, [9.920 3.968 1.984 0.992], 1e-3 );
%! assert( U, [0.198 0.794 0.794 0.595], 1e-3 );

## Example from table 3, p. 22, Herb Schwetman, "Implementing the Mean
## Value Algorith for the Solution of Queueing Network Models",
## Technical Report CSD-TR-355, Department of Computer Sciences, Purdue
## University, feb 15, 1982.
%!test
%! S = [1 0 .025; 0 15 .5];
%! V = [1 0 1; 0 1 1];
%! N = [2 1];
%! m = [-1 -1 1];
%! [U R Q X] = qncmmva(N,S,V,m);
%! assert( R(1,1), 1, 1e-3 );
%! assert( R(2,2), 15, 1e-3 );
%! assert( R(1,3), .027, 1e-3 );
%! assert( R(2,3), .525, 1e-3  );
%! assert( X(1,1)+X(1,2), 1.949, 1e-3 );
%! assert( X(2,1)+X(2,2), 0.064, 1e-3 );
%! assert( sum(Q,1), [1.949, .966, .085], 1e-3 );
%! assert( all(U(:,3)<=1) );
%! assert( Q, R.*X, 1e-5 ); # Little's Law

## Example from table 5, p. 23, Herb Schwetman, "Implementing the Mean
## Value Algorith for the Solution of Queueing Network Models",
## Technical Report CSD-TR-355, Department of Computer Sciences, Purdue
## University, feb 15, 1982.
%!test
%! S = [1 0 .025; 0 15 .5];
%! V = [1 0 1; 0 1 1];
%! N = [15 5];
%! m = [-1 -1 1];
%! [U R Q X] = qncmmva(N,S,V,m);
%! # I replaced 14.3->14.323
%! assert( U, [14.323 0 .358; 0 4.707 .157], 1e-3 );
%! # I replaced 14.3->14.323
%! assert( X, [14.323 0 14.323; 0 .314 .314 ], 1e-3 );
%! # I replaced 14.3->14.323
%! assert( Q, [14.323 0 .677; 0 4.707 .293 ], 1e-3 );
%! assert( R, [1 0 .047; 0 15 .934 ], 1e-3 );
%! assert( Q, R.*X, 1e-5 ); # Little's Law

## Example 9.5 p. 337, Bolch et al.
%!test
%! S = [ 0.2 0.4 1; 0.2 0.6 2 ];
%! V = [ 1 0.6 0.4; 1 0.3 0.7 ];
%! N = [ 2 1 ];
%! m = [ 2 1 -1 ];
%! [U R Q X] = qncmmva(N,S,V,m);
%! assert( Q, [ 0.428 0.726 0.845; 0.108 0.158 0.734 ], 1e-3 );
%! assert( X(1,1), 2.113, 1e-3 ); # CHECK
%! assert( X(2,1), 0.524, 1e-3 ); # CHECK
%! assert( all(U(:)<=1) );
%! assert( Q, R.*X, 1e-5 ); # Little's Law

## Multiclass network with two classes; however, class 2 has 0 requests.
## Therefore, we check that the results for class 1 are the same as those
## computed by the single-class MVA
%!test
%! C = 2; # two classes
%! K = 4; # four servers
%! S = V = zeros(C,K);
%! S(1,:) = linspace(1,2,K);
%! S(2,:) = linspace(2,3,K);
%! V(1,:) = linspace(4,1,K);
%! V(2,:) = linspace(6,3,K);
%! N = [10 0]; # class 2 has no customers
%! [U1 R1 Q1 X1] = qncmmva(N,S,V);
%! [U2 R2 Q2 X2] = qncsmva(N(1),S(1,:),V(1,:));
%! assert( U1(1,:), U2, 1e-5 );
%! assert( R1(1,:), R2, 1e-5 );
%! assert( Q1(1,:), Q2, 1e-5 );
%! assert( X1(1,:), X2, 1e-5 );

## This is example 5(b) page 7 of
## http://docs.lib.purdue.edu/cstech/259/
## "Testing network-of-queues software", technical report CSD-TR 330,
%!test
%! Z = [1 15];
%! V = [1; 1];
%! S = [.025; .5];
%! N = [15; 5];
%! [U R Q X] = qncmmva(N, S, V, 1, Z);
%! assert( U, [.358; .157], 1e-3 );
%! assert( Q, [.677; .293], 1e-3 );
%! assert( X, [14.323; .314], 1e-3 ); ## NOTE: X(1,1) = 14.3 in Schwetman
%! assert( R, [.047; .934], 1e-3 );
%! assert( Q, R.*X, 1e-5 ); # Little's Law

## This is example of Figure 6, page 9 of
## http://docs.lib.purdue.edu/cstech/259/
## "Testing network-of-queues software", technical report CSD-TR 330,
%!test
%! C = 2;
%! K = 6;
%! P = zeros(C,K,C,K);
%! P(1,1,1,2) = P(2,1,2,2) = 1;
%! P(1,2,1,3) = P(1,2,1,4) = P(1,2,1,5) = P(1,2,1,6) = .25;
%! P(2,2,2,3) = P(2,2,2,4) = P(2,2,2,5) = P(2,2,2,6) = .25;
%! P(1,3,1,1) = P(1,4,1,1) = P(1,5,1,1) = P(1,6,1,1) = .9;
%! P(1,3,1,2) = P(1,4,1,2) = P(1,5,1,2) = P(1,6,1,2) = .1;
%! P(2,3,2,1) = P(2,4,2,1) = P(2,5,2,1) = P(2,6,2,1) = .05;
%! P(2,3,2,2) = P(2,4,2,2) = P(2,5,2,2) = P(2,6,2,2) = .95;
%! N = [40 4];
%! S = [ 5.0 .010 .035 .035 .035 .035; ...
%!      10.0 .100 .035 .035 .035 .035 ];
%! V = qncmvisits(P);
%! [U R Q X] = qncmmva(N, S, V, [-1 1 1 1 1 1]);
%! # The results below were computed with JMVA; the numbers
%! # in the paper appears to be incorrect.
%! assert( U, [39.457941 0.087684 0.076724 0.076724 0.076724 0.076724; ...
%!              2.772704 0.554541 0.048522 0.048522 0.048522 0.048522 ], 1e-5 );
%! assert( R.*V, [5 0.024363 0.011081 0.011081 0.011081 0.011081; ...
%!                10 3.636155 0.197549 0.197549 0.197549 0.197549 ], 1e-5 );
%! assert( Q(:,1), [39.457941 2.772704]', 1e-5 );
%! assert( Q(:,2), [0.192262 1.008198]', 1e-5 );
%! assert( Q(:,3), [0.087449 0.054775]', 1e-5 );
%! assert( Q(:,4), Q(:,5), 1e-5 );
%! assert( Q(:,5), Q(:,6), 1e-5 );
%! assert( X(:,1), [7.891588 0.277270]', 1e-5 );
%! assert( X(:,2), [8.768431 5.545407]', 1e-5 );
%! assert( X(:,3), [2.192108 1.386352]', 1e-5 );
%! assert( X(:,4), X(:,5), 1e-5 );
%! assert( X(:,5), X(:,6), 1e-5 );
%! assert( Q, R.*X, 1e-5 ); # Little's Law

## If there is no class switching, we must get the same results as
## the plain application of multiclass MVA
%!test
%! C = 2; # two classes
%! K = 4; # four servers
%! C = 2; K = 4;
%! P = zeros(C,K,C,K);
%! S = zeros(C,K);
%!
%! # Routing
%!
%! # class 1 routing
%! P(1,1,1,1) = .05;
%! P(1,1,1,2) = .45;
%! P(1,1,1,3) = .5;
%! P(1,2,1,1) = 1;
%! P(1,3,1,1) = 1;
%! # class 2 routing
%! P(2,1,2,1) = .01;
%! P(2,1,2,3) = .5;
%! P(2,1,2,4) = .49;
%! P(2,3,2,1) = 1;
%! P(2,4,2,1) = 1;
%!
%! # Compute visits
%!
%! V = qncmvisits(P);
%!
%! # Define population and service times
%!
%! N = [3 2];
%! S = [0.01 0.09 0.10 0.08; ...
%!      0.05 0.09 0.10 0.08];
%! [U1 R1 Q1 X1] = qncmmva(N,S,V); # this invokes __qncmmva_nocs
%! [U2 R2 Q2 X2] = qncmmva(N,S,P); # this invokes __qncmmva_cs
%! assert( U2, U1, 1e-5 );
%! assert( R2, R1, 1e-5 );
%! assert( Q2, Q1, 1e-5 );
%! assert( X2, X1, 1e-5 );

## Example from table 5, p. 23, Herb Schwetman, "Implementing the Mean
## Value Algorith for the Solution of Queueing Network Models",
## Technical Report CSD-TR-355, Department of Computer Sciences, Purdue
## University, feb 15, 1982.
%!test
%! S = [1 0 .025; 0 15 .5];
%! V = [1 0 1; 0 1 1];
%! N = [15 5];
%! m = [-1 -1 1];
%! [U R Q X] = qncmmva(N,S,V,m);
%! assert( U, [14.323 0 .358; 0 4.707 .157], 1e-3 );
%! assert( R, [1.0 0 .047; 0 15 .934], 1e-3 );
%! assert( Q, [14.323 0 .677; 0 4.707 .293], 1e-3 );
%! assert( X, [14.323 0 14.323; 0 .314 .314], 1e-3 );

## Same test as above, but using routing probabilities instead of
## visits. Also, reordered the nodes such that server 1 is the PS node
## labeled "Sys 3" in the example; server 2 is the IS labeled "APL1" and
## server e is the IS labeled "IMS2"
%!test
%! S = [.025 1 15; .5 1 15 ];
%! P = zeros(2,3,2,3);
%! P(1,1,1,2) = P(1,2,1,1) = 1;
%! P(2,1,2,3) = P(2,3,2,1) = 1;
%! N = [15 5];
%! m = [1 -1 -1];
%! r = [1 1]; # reference station is station 1
%! [U R Q X] = qncmmva(N,S,P,r,m);
%! # I replaced 14.3->14.323
%! assert( U, [0.358 14.323 0; 0.156 0 4.707], 1e-3 );
%! # I replaced 14.3->14.323
%! assert( X, [14.323 14.3230 0; .314 0 .314 ], 1e-3 );
%! # I replaced 14.3->14.323
%! assert( Q, [.677 14.323 0; .293 0 4.707], 1e-3 );
%! assert( R, [.047 1 15.0; .934 1 15.0], 1e-3 );
%! assert( Q, R.*X, 1e-5 ); # Little's Law

## Example figure 9 Herb Schwetman "Implementing the Mean
## Value Algorith for the Solution of Queueing Network Models",
## Technical Report CSD-TR-355, Department of Computer Sciences, Purdue
## University, feb 15, 1982.
%!test
%! C = 2; K = 3;
%! S = [.01 .07 .10; ...
%!      .05 .07 .10 ];
%! P = zeros(C,K,C,K);
%! P(1,1,1,2) = .7;
%! P(1,1,1,3) = .2;
%! P(1,1,2,1) = .1;
%! P(2,1,2,2) = .3;
%! P(2,1,2,3) = .5;
%! P(2,1,1,1) = .2;
%! P(1,2,1,1) = P(2,2,2,1) = 1;
%! P(1,3,1,1) = P(2,3,2,1) = 1;
%! N = [3 0];
%! [U R Q X] = qncmmva(N, S, P);
%! assert( R, [.015 .133 .163; .073 .133 .163], 1e-3 );
%! assert( X, [12.609 8.826 2.522; 6.304 1.891 3.152], 1e-3 );
%! assert( Q, [.185 1.175 .412; .462 .252 .515], 1e-3 );
%! assert( U, [.126 .618 .252; .315 .132 .315], 1e-3 );


## Example from Schwetman (figure 7, page 9 of
## http://docs.lib.purdue.edu/cstech/259/
## "Testing network-of-queues software, technical report CSD-TR 330,
## Purdue University). Note that the results for that network (table 9
## of the reference above) seems to be wrong. The "correct" results
## below have been computed using the multiclass MVA implementation of
## JMT (http://jmt.sourceforge.net/)
%!test
%! V = [ 1.00 0.45 0.50 0.00; ...
%!       1.00 0.00 0.50 0.49 ];
%! N = [3 2];
%! S = [0.01 0.09 0.10 0.08; ...
%!      0.05 0.09 0.10 0.08];
%! [U R Q X] = qncmmva(N, S, V);
%! assert( U, [ 0.1215 0.4921 0.6075 0.0000; ...
%!              0.3433 0.0000 0.3433 0.2691 ], 1e-4 );
%! assert( Q, [ 0.2131 0.7539 2.0328 0.0000; ...
%!              0.5011 0.0000 1.1839 0.3149 ], 1e-4 );
%! assert( R.*V, [0.0175 0.0620 0.1672 0.0000; ...
%!                0.0729 0.0000 0.1724 0.0458 ], 1e-4 );
%! assert( X, [12.1517 5.4682 6.0758 0.0000; ...
%!              6.8669 0.0000 3.4334 3.3648 ], 1e-4 );

## The following test case was used in a bug report from F. Paolieri. It
## consists of a three-class network with four nodes. There is just
## one job for each class n; that job visits node 1 and node 1+n.
## Singe service times at nodes 2:4 are all the same, and service time
## at node 1 is class-independent, we expect that all performance
## measures for nodes 2:4 are equal.
%!test
%! N = [1   1   1];
%! S = [0.20000   0.02000   0.00000   0.00000;
%!      0.20000   0.00000   0.02000   0.00000;
%!      0.20000   0.00000   0.00000   0.02000];
%! V = [1   1   0   0;
%!      1   0   1   0;
%!      1   0   0   1];
%! [U R Q X] = qncmmva(N,S,V);
%! assert( Q(1,2), Q(2,3), 1e-5);
%! assert( Q(2,3), Q(3,4), 1e-5);
%! assert( abs(max(Q(:,1)) - min(Q(:,1))) < 1e-5 );

## This example is from G. Casale and G. Serazzi. Quantitative system
## evaluation with java modeling tools. In Proceedings of the second
## joint WOSP/SIPEW international conference on Performance engineering,
## ICPE '11, pages 449-454, New York, NY, USA, 2011. ACM
%!demo
%! Ntot = 100; # total population size
%! b = linspace(0.1,0.9,10); # fractions of class-1 requests
%! S = [20 80 31 14 23 12; ...
%!      90 30 33 20 14 7];
%! V = ones(size(S));
%! X1 = X1 = XX = zeros(size(b));
%! R1 = R2 = RR = zeros(size(b));
%! for i=1:length(b)
%!   N = [fix(b(i)*Ntot) Ntot-fix(b(i)*Ntot)];
%!   # printf("[%3d %3d]\n", N(1), N(2) );
%!   [U R Q X] = qncmmva( N, S, V );
%!   X1(i) = X(1,1) / V(1,1);
%!   X2(i) = X(2,1) / V(2,1);
%!   XX(i) = X1(i) + X2(i);
%!   R1(i) = dot(R(1,:), V(1,:));
%!   R2(i) = dot(R(2,:), V(2,:));
%!   RR(i) = Ntot / XX(i);
%! endfor
%! subplot(2,1,1);
%! plot(b, X1, ";Class 1;", "linewidth", 2, ...
%!      b, X2, ";Class 2;", "linewidth", 2, ...
%!      b, XX, ";System;", "linewidth", 2 );
%! legend("location","south"); legend("boxoff");
%! ylabel("Throughput");
%! subplot(2,1,2);
%! plot(b, R1, ";Class 1;", "linewidth", 2, ...
%!      b, R2, ";Class 2;", "linewidth", 2, ...
%!      b, RR, ";System;", "linewidth", 2 );
%! legend("location","south"); legend("boxoff");
%! xlabel("Population mix \\beta for Class 1");
%! ylabel("Resp. Time");

%!demo
%! S = [1 0 .025; 0 15 .5];
%! P = zeros(2,3,2,3);
%! P(1,1,1,3) = P(1,3,1,1) = 1;
%! P(2,2,2,3) = P(2,3,2,2) = 1;
%! V = qncmvisits(P,[3 3]); # reference station is station 3
%! N = [15 5];
%! m = [-1 -1 1];
%! [U R Q X] = qncmmva(N,S,V,m)


## Example shown on Figure 9: Herb Schwetman, "Implementing the Mean
## Value Algorith for the Solution of Queueing Network Models",
## Technical Report CSD-TR-355, Department of Computer Sciences, Purdue
## University, feb 15, 1982.
%!demo
%! C = 2; K = 3;
%! S = [.01 .07 .10; ...
%!      .05 .07 .10 ];
%! P = zeros(C,K,C,K);
%! P(1,1,1,2) = .7; P(1,1,1,3) = .2; P(1,1,2,1) = .1;
%! P(2,1,2,2) = .3; P(2,1,2,3) = .5; P(2,1,1,1) = .2;
%! P(1,2,1,1) = P(2,2,2,1) = 1;
%! P(1,3,1,1) = P(2,3,2,1) = 1;
%! N = [3 0];
%! [U R Q X] = qncmmva(N, S, P)

%!demo
%! S = [10 7 5 4;
%!      5  2 4 6];
%! NN = 100;
%! Xl_aba = Xu_aba = Xl_bsb = Xu_bsb = Xl_cb = Xu_cb = ...
%! Xmva = Rmva = zeros(NN,2);
%! for n=1:NN
%!   N=[n,10];
%!   [a b] = qncmaba(N,S);
%!   Xl_aba(n,:) = a; Xu_aba(n,:) = b;
%!   [a b] = qncmbsb(N,S);
%!   Xl_bsb(n,:) = a; Xu_bsb(n,:) = b;
%!   [a b] = qncmcb(N,S);
%!   Xl_cb(n,:) = a; Xu_cb(n,:) = b;
%!   [U R Q X] = qncmmva(N,S,ones(size(S)));
%!   Xmva(n,:) = X(:,1)';
%! endfor
%! subplot(1,2,1);
%! plot(1:NN, Xl_aba(:,1), "-g",
%!      1:NN, Xu_aba(:,1), "-g;ABA;",
%!      1:NN, Xu_bsb(:,1), "-r;BSB;",
%!      1:NN, Xl_cb(:,1), "-b",
%!      1:NN, Xu_cb(:,1), "-b;CB;",
%!      1:NN, Xmva(:,1), "-k;MVA;", "linewidth", 2);
%! xlabel("N. of requests");
%! ylim([0, 0.2]);
%! title("Class 1 throughput"); legend("boxoff");
%! subplot(1,2,2);
%! plot(1:NN, Xl_aba(:,2), "-g",
%!      1:NN, Xu_aba(:,2), "-g;ABA;",
%!      1:NN, Xu_bsb(:,2), "-r;BSB;",
%!      1:NN, Xl_cb(:,2), "-b",
%!      1:NN, Xu_cb(:,2), "-b;CB;",
%!      1:NN, Xmva(:,2), "-k;MVA;", "linewidth", 2);
%! xlabel("N. of requests");
%! ylim([0, 0.2]);
%! title("Class 2 throughput");
%! legend("boxoff");
%! legend("location", "east");
