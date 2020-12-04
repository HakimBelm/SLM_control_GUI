function f_SLM_upload_image_to_SLM(app)
% add AO correction if on
SLM_image = f_SLM_AO_add_correction(app, app.SLM_Image, app.current_SLM_AO_Image);
app.SLM_Image_pointer.Value = f_SLM_im_to_pointer(SLM_image);
f_SLM_BNS_update(app.SLM_ops, app.SLM_Image_pointer);

end