c = Context;
l = Logger;

for trial = 1:c.nTrial
   current = c.extractTrial(trial);
   try
      l.writeData(trial, current);
   catch ME
      error(ME);
      warning('Cannot write to file!');
      l.closeInstance;
   end
end

fprintf('Done!\n');
l.closeInstance;