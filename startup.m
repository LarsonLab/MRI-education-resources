global isOctave;
isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;

if ~isdeployed
addpath(genpath(fileparts(mfilename('fullpath'))))


% Remove temp dir from path if it exists
tmpDir = fullfile(pwd, 'tmp');
if exist(tmpDir, 'dir')
    rmpath(genpath(tmpDir))
end


if ~isOctave % MATLAB
    % Test Signal Processing toolbox is installed
    if ~license('test', 'Signal_Toolbox'), error('Signal Processing Toolbox is not installed on your system: some RF pulse designs won''t work.'); end
    if ~license('test', 'Image_Toolbox'), warning('Image Toolbox is not installed: some display functions will not work. Consider installing <a href="matlab:matlab.internal.language.introspective.showAddon(''IP'');">Image Processing Toolbox</a>'); end
else % OCTAVE
    % install octave package
    installlist = {'image', 'signal'};
    for ii=1:length(installlist)
        try
            disp(['loading ' installlist{ii}])
            pkg('load',installlist{ii})
        catch
            errorcount = 1;
            while errorcount % try to install 30 times (Travis)
                try
                    pkg('install','-forge',installlist{ii})
                    pkg('load',installlist{ii})
                    errorcount = 0;
                catch err
                    errorcount = errorcount+1;
                    if errorcount>30
                        error(err.message)
                    end
                end
            end
        end
    end

end
end