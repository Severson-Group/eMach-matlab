function [dataPoints] = mn_getCurveValues(mn, doc, pid, command, isField, isTimeAveraged)
%MN_GetCurveValues Worker function used to retrieve various solution data
%
%       mn:  reference to open MagNet project
%       doc: reference to document within MagNet project
%       pid: problem ID (1 if only one problem is defined)
%       command: the command that this function should call to collect data
%           ie see 'MagNet_ReadCircuitCompVoltage'
%       isField: 1 if this is a field quantity, otherwise 0
%       isTimeAveraged: 1 if this is time averaged, otherwise 0
%   
%
%   Returns dataPoints: column 1 is the time stamp, other columns are the
%   data
%

   Sol = invoke(doc, 'GetSolution'); 
   
   if invoke(Sol, 'isSolved') == 1
      IsTransient = invoke(Sol, 'isTransient');
      if (IsTransient ==1 && isTimeAveraged==0) 
         invoke(mn, 'processcommand', 'ReDim XValues(0)');
         if isField == 1             
             invoke (mn, 'processcommand', ['getDocument.getSolution.getFieldSolutionTimeInstants(' num2str(pid) ', XValues) - 1']);             
         else
             invoke (mn, 'processcommand', ['getDocument.getSolution.getGlobalSolutionTimeInstants ' num2str(pid) ', XValues']);
         end
         invoke (mn,  'processcommand', 'Call setVariant(0, XValues, "MATLAB")');         
         Temp = invoke (mn,  'getVariant', 0, 'MATLAB');
         XValues = zeros(length(Temp),1);
         for i = 1:length(Temp)
             XValues(i) = Temp{i};
         end
         UValues = length(XValues);
      else
            invoke(mn, 'processcommand', 'ReDim XValues(0)');
            invoke(mn, 'processcommand', ['XValues(0) = ' num2str(pid)]);
            UValues = 1;
      end
     
      invoke(mn, 'processcommand', ['ReDim DataPoints(' num2str(UValues-1) ', 1)']);
      for i = 1 : UValues
          n = i-1;
         if (IsTransient == 1 && isTimeAveraged == 0) 
             invoke(mn, 'processcommand', ['ReDim SolutionID(1) : SolutionID(0)= ' num2str(pid) ' : SolutionID(1)= XValues(' num2str(n) ')']); 
         else
             invoke(mn, 'processcommand', ['SolutionID= XValues(' num2str(n) ')']);
         end
         
         invoke(mn, 'processcommand', command);
         invoke(mn, 'processcommand', ['DataPoints(' num2str(n) ', 0)= XValues(' num2str(n) ') : DataPoints(' num2str(n) ', 1)= Result']);                  
      end
      
      invoke (mn,  'processcommand', 'Call setVariant(0, DataPoints, "MATLAB")');   
      Temp = invoke (mn,  'getVariant', 0, 'MATLAB');
      dim = size(Temp);
      dataPoints = zeros(dim(1), dim(2));
        for x = 1:dim(1)
            for y = 1:dim(2)
                dataPoints(x,y) = Temp{x,y};
            end
        end
   end 
   
end