module AC2D
export
    # 2D forward autocorrelation wavelet transform
    ac2d,
    # inverse 2D autocorrelation wavelet transform
    iac2d
using ..AC1D

"""
  ac1d_col(x, L, P, Q)

Computes the column wise 1D fwt_ac coeficients for 2D signals.

### Arguments
- `x`: 2D signal (n ,m) matrix
- `L`: Decomposition level
- `P`: Low AC shell filter
- `Q`: High AC shell filter

Returns a multidimensional array of (num_col, levels_of_decomposition)
"""
function ac1d_col(x, L, P, Q)
    num_row, num_col = size(x)
    J = trunc(Integer, log2(num_row))
    D = J - L + 1
    accoef_matrix_3d = Array{Float64, 3}(undef, num_row, D, num_col)
    for i in 1:num_col
        accoef_matrix_3d[:,:,i] = fwt_ac(x[:,i],L,P,Q)
    end
    return accoef_matrix_3d
end

"""
  ac1d_row(x, L, P, Q)

Computes the row wise 1D fwt_ac coeficients for 2D signals.

### Arguments
- `x`: 2D signal (n ,m) matrix
- `L`: Decomposition level
- `P`: Low AC shell filter
- `Q`: High AC shell filter

Returns a multidimensional array of (num_col, levels_of_decomposition)
"""
function ac1d_row(x, L, P, Q)
    num_row, num_col = size(x)
    J = trunc(Integer, log2(num_col))
    D = J - L + 1
    accoef_matrix_3d = Array{Float64, 3}(undef, num_col, D, num_row)
    for i in 1:num_row
        accoef_matrix_3d[:,:,i] = fwt_ac(x[i,:],L,P,Q)
    end
    return accoef_matrix_3d
end

# ------- Two dimensional functions --------
"""
  ac2d(x, L_row, L_col, P, Q)

Computes autocorrelation wavelet coeficients for 2D signals.

### Arguments
- `x`: 2D signals (n ,m) matrix
- `L_row`: Decomposition level of rows
- `L_col`: Decomposition level of columns
- `P`: Low AC shell filter
- `Q`: High AC shell filter

Returns a the multidimensional matrix of
(num_rows, num_cols, levels_of_decomp, levels_of_decomp) that stores
the coefficients of the decomposed image.
"""
function ac2d(x, L_row, L_col, P, Q)
    num_row, num_col = size(x)
    J_row = trunc(Integer, log2(num_col))
    J_col = trunc(Integer, log2(num_row))
    D_row = J_row - L_row + 1
    D_col = J_col - L_col + 1
    accoef_matrix_3d = ac1d_col(x, L_col, P, Q)
    accoef_matrix_4d = Array{Float64, 4}(undef, D_col, num_col, D_row, num_row)
    for i in 1:D_col
        accoef_matrix_4d[i,:,:,:] = ac1d_row(accoef_matrix_3d[:,i,:], L_row,P,Q)
    end
    accoef_matrix_4d = permutedims(accoef_matrix_4d, [4,2,3,1])
    return accoef_matrix_4d
end

# ------------ Inverse functions -------------
"""
    iac2d(x)

Performs the inverse 2D autocorrelation wavelet transform.

# Arguments
- `x`: ac2d function output
"""
function iac2d(x)
    num_row, num_col, D_row, D_col = size(x)
    accoef_matrix_4d = permutedims(x, [4,2,3,1])
    accoef_matrix_3d = Array{Float64, 3}(undef, num_row, D_col, num_col)
    for i in 1:D_col
        for j in 1:num_row
            accoef_matrix_3d[j,i,:] = iwt_ac(accoef_matrix_4d[i,:,:,j])
        end
    end
    reconst = Array{Float64, 2}(undef, num_row, num_col)
    for i in 1:num_col
        reconst[:,i] = iwt_ac(accoef_matrix_3d[:,:,i])
    end
    return reconst
end

end # module
