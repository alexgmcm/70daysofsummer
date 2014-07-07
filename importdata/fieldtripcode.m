
addpath('/home/alexgmcm/Documents/MATLAB/FieldTrip/fieldtrip-20140518');
ft_defaults;


cfg = [];
cfg.length=5;%5 second epoch length
data_ref=ft_redefinetrial(cfg, data_org);