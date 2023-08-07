program read_wrf

    implicit none

    character(len=*), parameter :: fname='./wrfout_d04_2008-06-14_08:00:00'
    real, dimension(:,:,:,:), allocatable :: var_4d
    real, parameter :: badpt=-999.

    call get_wrf_var_4d_real(fname, "QRAIN", var_4d)
    write(*,'(a,2f8.2)')'QRAIN WRF : MIN/MAX',MINVAL(var_4d,var_4d/=badpt),MAXVAL(var_4d)
    
contains

    subroutine get_wrf_var_4d_real(file, var_name_in, var_4d_data)

        implicit none
        include 'netcdf.inc'
        character(len=*), intent(in)  :: file
    
        character(len=*), intent(in) :: var_name_in
        integer :: i, ierr, ncid, varid, ndims, dim_ids_4d(4), dim_len_4d(4)
        real, dimension(:,:,:,:), allocatable :: var_4d_data
    
        ierr = nf_open(trim(file), NF_NOWRITE, ncid )
        ierr = nf_inq_varid(ncid, var_name_in, varid)
        ierr = nf_inq_varndims(ncid, varid, ndims)
    
        if( ndims == 4 ) then
            do i=1, ndims
                ierr = nf_inq_vardimid(ncid, varid, dim_ids_4d)
                ierr = nf_inq_dimlen(ncid, dim_ids_4d(i), dim_len_4d(i))
            enddo
            allocate(var_4d_data(dim_len_4d(1), dim_len_4d(2), dim_len_4d(3), dim_len_4d(4)))
            ierr = nf_get_var_real(ncid, varid, var_4d_data)
        else
            print*, "Error: "//var_name_in//"is NOT 4d variable."
            print*, "   ndim = ", ndims
        endif
    
    end subroutine

end program read_wrf
