function decisiones = rechazo_artefactos2(senyal)

% RECHAZO_ARTEFACTOS2 Realiza una seleccion de los segmentos de una señal
%       que tienen un valor superior a un umbral determinado en funcion del
%       valor maximo de su mediana.
%
%		RECHAZO_ARTEFACTOS2(senyal):
%       devuelve un vector de 1's y 0's indicando si las épocas de la señal
%       que pueden analizarse (1) y las que se consideran artefactadas (0).
%       Se parte de la totalidad del canal (50863 puntos) y se decide si
%       las épocas están contaminadas por artefactos en función de un
%       umbral variable que depende del valor mediano de sus máximos.
%
% Versión: 1.3.
%
% Fecha de creación: 1 de Abril de 2005.
%
% Última modificación: 18 de Abril de 2008.
%
% Autor: Jesús Poza Crespo.
%
% Modificado por Javier Escudero Rodríguez
%

% Se inicializan las variables que se devuelven.
decisiones = [];

% Se inicializan las variables de configuracion de la seleccion de
% segmentos.
long_segmentos = 100;   % Longitud de los segmentos.
num_segmentos = floor(length(senyal)/long_segmentos); % Numero de segmentos

escala = 4; % Escala del valor mediano que servira como umbral.
% !!!!
% Cambiar aquí la longitud de las épocas
% !!!!
N = 1695;   % Numero de muestras de cada segmento: 50863, 8477, 3390, 1695

% Evaluamos la presencia de artefactos sobre la señal tal cual nos la pasan
% Para poder comparar con umbrales, eliminamos la componente continua,
% restando la mediana de la señal.
senyal_sin_mediana = senyal-median(senyal);

% Se calculan los valores maximos y minimos de la señal, tomando
% 'num_segmentos' trozos de 'long_segmentos' muestras.
x_max_med=[]; x_min_med=[];
x_max=[]; x_min=[];
for i=1:num_segmentos,
    x_max = max(senyal_sin_mediana(1+(i-1)*long_segmentos:i*long_segmentos));
    if x_max > 0, % El maximo sera positivo.
        x_max_med = [x_max_med x_max];
    end % Fin del 'if' que toma los valores maximos.
    x_min = min(senyal_sin_mediana(1+(i-1)*long_segmentos:i*long_segmentos));
    if x_min < 0, % El minimo sera negativo.
        x_min_med = [x_min_med x_min];
    end % Fin del 'if' que toma los valores minimos.
end % Fin del 'for' que toma los maximos y minimos de cada trozo.

if max(senyal_sin_mediana(num_segmentos*long_segmentos:length(senyal_sin_mediana)))>0,
    x_max_med = [x_max_med max(senyal_sin_mediana(num_segmentos*long_segmentos:length(senyal_sin_mediana)))];
end % Fin del 'if' que toma el maximo del trozo sobrante.
if min(senyal_sin_mediana(num_segmentos*long_segmentos:length(senyal_sin_mediana)))<0,
    x_min_med = [x_min_med min(senyal_sin_mediana(num_segmentos*long_segmentos:length(senyal_sin_mediana)))];
end % Fin del 'if' que toma el minimo del trozo sobrante.
% Se calculan las medianas del maximo y del minimo.
max_med = escala*median(x_max_med);
min_med = escala*median(x_min_med);

% Seleccion de los segmentos de N muestras de la señal filtrada que no
% superen los umbrales.
for k=1:floor(length(senyal)/N),

    trozo = senyal_sin_mediana(1+(k-1)*N:k*N);
%    if max(trozo)<max_med & min(trozo)>min_med & max(trozo)<umbral_fijo & min(trozo)>-umbral_fijo,
    if max(trozo)<max_med & min(trozo)>min_med,
%    if max(trozo)<umbral_fijo & min(trozo)>-umbral_fijo,
        %segmentos = [segmentos senyal_sin_mediana(1+(k-1)*N:k*N)];
	  %indices = [indices k];
      decisiones(k,1) = 1; % LIBRE DE ARTEFACTOS
%         fprintf(fid_seleccion, '\tSegmento: %d\n', k);
    else
        decisiones(k,1) = 0; % ARTEFACTADO
    end % Fin del 'if' que comprueba el primer trozo.

end % Fin del 'for' que recorre los segmentos de N muestras.

decisiones = decisiones(:);
