function f_sg_reg_update(app)
% set region values in app window

% select region
reg_idx = strcmpi({app.region_list.reg_name},app.SelectRegionDropDown.Value);

% select region_objective params
reg_obj_params = app.region_obj_params(strcmpi({app.region_obj_params.reg_name},app.SelectRegionDropDown.Value));
if ~isempty(reg_obj_params)
    reg_obj_params = reg_obj_params(strcmpi({reg_obj_params.obj_name},app.ObjectiveDropDown.Value));
end
if isempty(reg_obj_params)
    reg_obj_params = app.SLM_ops.default_region_params;
end

if sum(reg_idx)
    reg1 = app.region_list(reg_idx);
    app.RegionnameEditField.Value = reg1.reg_name;
    app.regionheightminEditField.Value = reg1.height_range(1);
    app.regionheightmaxEditField.Value = reg1.height_range(2);
    app.regionwidthminEditField.Value = reg1.width_range(1);
    app.regionwidthmaxEditField.Value = reg1.width_range(2);
    
    % load region obj params
    app.regionWavelengthnmEditField.Value = reg_obj_params.wavelength;
    app.regionBeamDiameterEditField.Value = reg_obj_params.beam_diameter;
    app.regionEffectiveNAEditField.Value = reg_obj_params.effective_NA;
    
    % update dropdown
    lut_fname = {app.LUTDropDown.Value};
    lut_corr_fname = {'None'};
    
    % load saved correction value
    if isfield(reg1, 'lut_correction_fname')
        if ~isempty(reg1.lut_correction_fname)
            save_idx = strcmpi(lut_fname, reg1.lut_correction_fname(:,1));
            if sum(save_idx)
                lut_corr_fname = reg1.lut_correction_fname(save_idx,2);
            end
        end
    end
    
    app.LUTcorrectionDropDown.Items = app.lut_corrections_list(:,1);
    app.LUTcorrectionDropDown.Value = lut_corr_fname;
    
    if isempty(reg1.xyz_affine_tf_fname)
        app.XYZaffinetransformDropDown.Value = {'None'};
    else
        app.XYZaffinetransformDropDown.Value = reg1.xyz_affine_tf_fname;
    end

    if isempty(reg1.AO_correction_fname)
        app.AOcorrectionDropDown.Value = {'None'};
    else
        app.AOcorrectionDropDown.Value = reg1.AO_correction_fname;
    end
    
else
    disp('Region update failed')
end

end


