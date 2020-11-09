function f_SLM_pat_add(app)

idx1 = strcmpi(app.GroupnameEditField.Value, [app.xyz_patterns.name_tag]);

if ~sum(idx1)
    pat1.name_tag = {app.GroupnameEditField.Value};
    pat1.SLM_reg = app.GroupRegionDropDown.Value;
    pat1.xyz_pts = app.UIImagePhaseTable.Data;

    app.xyz_patterns = [app.xyz_patterns; pat1];
    
    app.PatterngroupDropDown.Items = [app.xyz_patterns.name_tag];
    app.PatterngroupDropDown.Value = pat1.name_tag;
    app.PatternDropDownCtr.Items = [{'None'}, app.xyz_patterns.name_tag];
    app.PatternDropDownAI.Items = [{'None'}, app.xyz_patterns.name_tag];
else
    disp('Pattern add failed, make a unique name');
end


end