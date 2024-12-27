function error = alignmentError(x, pp_G_C, p_V_C)

    homo = twist2HomogMatrix(x);
    R = homo(1:3, 1:3);
    t = homo(1:3, 4);
    s = x(length(x));

    error = s * R * p_V_C + t - pp_G_C;
end