function [scenario, technology] = get_test(filename)
  if strcmp(filename,'')
    return
  end
  fileID = fopen(filename,'r');
  scenario = fgets(fileID);
  technology = fgets(fileID);

  % for space separated values:
  % formatSpec = '%s';
  % txt = fscanf(fileID,formatSpec);
  % scenario = txt(1);
  % technology = txt(2);
end