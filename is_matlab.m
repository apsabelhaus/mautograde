function flag=is_matlab()
ver_info=ver();
flag=any(strcmp({ver_info.Name},'MATLAB'));