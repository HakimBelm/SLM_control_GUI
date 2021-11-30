function f_sg_scan_initialize_imaging(app)

if app.InitializeimagingButton.Value
    init_image_lut = app.SLM_phase_lut_corr;
    try
        disp('Initializing multiplane imaging...');
        time_stamp = clock;
        
        [holo_patterns_im, im_params] = f_sg_scan_make_images(app, app.PatternDropDownCtr.Value);
        
        num_planes = size(holo_patterns_im,3);
        volumes = app.NumVolumesEditField.Value;
        num_scans_all = num_planes*volumes;

        if ~strcmpi(app.PatternDropDownAI.Value, 'none')
            [holo_patterns_stim, stim_params] = f_sg_scan_make_images(app, app.PatternDropDownAI.Value, 0);
            num_stim = size(holo_patterns_stim,3);
        else
            num_stim = 0;
        end
        
        if ~num_stim % of only imaging
            holo_pointers = cell(num_planes,1);
            for n_gr = 1:num_planes
                holo_phase = init_image_lut;
                holo_phase(im_params.m_idx, im_params.n_idx) = holo_patterns_im(:,:, n_gr);
                holo_pointers{n_gr,1} = f_sg_initialize_pointer(app);
                holo_pointers{n_gr,1}.Value = reshape(holo_phase', [],1);
                %figure; imagesc(reshape(holo_pointers{n_gr,1}.Value, [1920 1152])')
            end
            app.ImagingReadyLamp.Color = [0.00,1.00,0.00];
            
            if app.ScanwithSLMtriggersCheckBox.Value
                scan_data = f_sg_EOF_Zscan_trig(app, holo_pointers, num_scans_all, app.InitializeimagingButton);
            else
                scan_data = f_sg_EOF_Zscan(app, holo_pointers, num_scans_all, app.InitializeimagingButton);
            end
            
        else
            holo_pointers = cell(num_planes,num_stim+1);
            for n_gr = 1:num_planes
                holo_phase = zeros(size(init_image_lut), 'uint8');
                holo_phase(im_params.m_idx, im_params.n_idx) = holo_patterns_im(:,:, n_gr);
                holo_pointers{n_gr,1} = f_sg_initialize_pointer(app);
                holo_pointers{n_gr,1}.Value = reshape(holo_phase', [],1);
                % figure; imagesc(reshape(holo_pointers{n_gr,1}.Value, [1920 1152])')
                for n_st = 1:num_stim
                    holo_phase(stim_params.m_idx, stim_params.n_idx) = holo_patterns_stim(:,:, n_st);
                    holo_pointers{n_gr,n_st+1} = f_sg_initialize_pointer(app);
                    holo_pointers{n_gr,n_st+1}.Value = reshape(holo_phase', [],1);
                    % figure; imagesc(reshape(holo_pointers{n_gr,n_st+1}.Value, [1920 1152])')
                end
            end
            
            app.ImagingReadyLamp.Color = [0.00,1.00,0.00];
            
            scan_data = f_sg_EOF_Zscan_stim(app, holo_pointers, num_scans_all, app.InitializeimagingButton);
            %f_sg_scan_EOF_trig(app, holo_pointers, num_scans_all, app.InitializeimagingButton);
            
            scan_data.stim_pattern = app.PatternDropDownAI.Value;
        end
        app.InitializeimagingButton.Value = 0;
        app.ImagingReadyLamp.Color = [0.80,0.80,0.80];
        
        if app.PlotSLMupdateratesCheckBox.Value
            if numel(scan_data.frame_start_times)>3
                figure;
                plot(diff(scan_data.frame_start_times(2:end-1)));
                xlabel('frame'); ylabel('time (ms)');
                title('SLM update rate');
            end
        end
        scan_data.im_pattern = app.PatternDropDownCtr.Value;
        scan_data.volumes = volumes;
        
        name_tag = sprintf('%s\\%s_%d_%d_%d_%dh_%dm',...
            app.SLM_ops.save_dir,...
            'mpl_scan', ...
            time_stamp(2), time_stamp(3), time_stamp(1)-2000, time_stamp(4),...
            time_stamp(5));
        
        save([name_tag '.mat'], 'scan_data');
   
        disp('Done');
        %figure; imagesc(f_sg_poiner_to_im(holo_pointers{1}, 1152, 1920));
    catch
        app.InitializeimagingButton.Value = 0;
        app.ImagingReadyLamp.Color = [0.80,0.80,0.80];
        disp('Imaging run failed')
    end
    app.SLM_phase_corr_lut = init_image_lut;
    f_sg_upload_image_to_SLM(app);
else
    app.ImagingReadyLamp.Color = [0.80,0.80,0.80];
end


end