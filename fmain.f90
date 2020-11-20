! -*- coding: utf-8 -*-

program main
  implicit none

  real(8), allocatable :: aa(:, :), bb(:, :), cc(:, :)
  integer :: n

  integer :: seedsize
  integer,allocatable :: seed(:)

  integer(8) :: c1, c2, cr, cm

  write(*,*) ''
  write(*,*) '# Fortran Blas Lapack benchmark'

  open(1000, file='input', status='old')
  read(1000,*) n
  close(1000)

  allocate(aa(n, n), bb(n, n), cc(n, n))

  call random_seed(size=seedsize)
  allocate(seed(seedsize))
  call random_seed(get=seed)

  write(*,*) "seedsize", seedsize
  write(*,*) "seed", seed

  call random_number(aa)
  call random_number(bb)
  cc = 0d0

  ! matmul multiplication
  call system_clock(c1,cr,cm)
  cc = matmul(aa, bb)
  call system_clock(c2,cr,cm)
  write(*,*) 'matmul multiplication time', dble(c2-c1)/dble(cr)

  ! dgemm multiplication
  cc = 0d0
  call system_clock(c1,cr,cm)
  ! call DGEMM(TRANSA,TRANSB,M,N,K,ALPHA,A,LDA,B,LDB,BETA,C,LDC)
  call DGEMM("N","N",n,n,n,1d0,aa,n,bb,n,1d0,cc,n)
  call system_clock(c2,cr,cm)
  write(*,*) 'dgemm multiplication time', dble(c2-c1)/dble(cr)

  ! inverse
  call system_clock(c1,cr,cm)
  call matinv(n, aa, n)
  call system_clock(c2,cr,cm)
  write(*,*) 'inverse time', dble(c2-c1)/dble(cr)

  ! LU decomposition
  block
    integer :: info
    integer, allocatable :: ipiv(:)

    allocate(ipiv(n))
    ipiv = 0

    call system_clock(c1,cr,cm)
    call dgetrf(n, N, bb, n, IPIV, INFO)
    call system_clock(c2,cr,cm)
    write(*,*) 'LU decomposition time', dble(c2-c1)/dble(cr)

    ! rank-revealing QR
    ipiv = 0
    call random_number(aa)
    call system_clock(c1,cr,cm)
    call matqr_all(aa, ipiv)
    call system_clock(c2,cr,cm)
    write(*,*) 'rank-revealing QR time', dble(c2-c1)/dble(cr)
  end block

  stop

contains
!-----------------------
  subroutine matinv(N, A, LDA)
    implicit none

    integer,intent(in) :: n
    real(8),intent(inout) :: a(:,:)
    integer,intent(in) :: lda

    real(8),allocatable :: work(:)
    integer :: lwork
    integer :: info
    integer, allocatable :: ipiv(:)

    if(size(a(1,:)) .ne. size(a(:,1))) then
       call force_raise()
    end if

    allocate(ipiv(n),work(1))

    call dgetrf(n, N, A, LDA, IPIV, INFO)

    lwork=-1

    call dgetri(N, A, LDA, IPIV, WORK, LWORK, INFO)

    lwork = int(work(1)+0.1d0)
    deallocate(work)
    allocate(work(lwork))

    call dgetri(N, A, LDA, IPIV, WORK, LWORK, INFO)

    if(info.ne.0) then
       write(6,*) 'dgetri', info
       write(*,*) 'matinv a check'
       call force_raise()
       stop 'subroutine matinv'
    endif

    deallocate(ipiv,work)

    return
  end subroutine matinv
!-----------------------
  subroutine matqr_all(a, ipvt)
    implicit none

    real(8),intent(inout) :: a(:,:)
    integer,intent(inout) :: ipvt(:)

    real(8), allocatable :: work(:)
!    real(8),allocatable :: rwork(:)
    real(8), allocatable :: tau(:)
    integer :: na
    integer :: nn
    integer :: lwork
    integer :: info

    na = size(a(:, 1))
    nn = size(a(1, :))

    allocate(work(1))
!    allocate(rwork(2*nn))
    allocate(tau(min(na, nn)))

    lwork = -1
!    call zgeqp3(na,nn,a,na,ipvt,tau,work,lwork,rwork,info)
    call dgeqp3(na,nn,a,na,ipvt,tau,work,lwork,info)
    if(info .ne. 0) then
       write(*,*) 'info', info
       call force_raise()
    end if

    lwork = max(int(work(1)+0.1d0),na,1) + 1
    deallocate(work)
    allocate(work(lwork))

!    call zgeqp3(na,nn,a,na,ipvt,tau,work,lwork,rwork,info)
    call dgeqp3(na,nn,a,na,ipvt,tau,work,lwork,info)
    if(info .ne. 0) then
       write(*,*) 'info', info
       call force_raise()
    end if

  end subroutine matqr_all
  !----------------------------------------------------------------
  subroutine force_raise()
    implicit none

    integer :: zero

    zero = 0
    write(*,*) '# force raise !!'
    write(*,*) '# error', 0/zero
    stop

  end subroutine force_raise
!-----------------------
end program main
