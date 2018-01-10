function delays = compute_delays_up_down(Adjacency_mat, n_bits)
  % only supports singlepath - meaning only one non-zero (positive)
  % number per membership matrix row.
  % We can not simply use max(column) to identify the highest delay.
  % We would need to check the delays on the higher levels of abstraction to
  % choose an optimal path to the graph's root.
  % For simplicity then, we will skip this analysis and focus on singlepath.
  % INPUT
  %   AdjacencyMat .. Adjacency matrix N x M where N > M
  %                   (N= original data count, M= k)
  % OUTPUT
  %   delays ..      1xN vector of delays
  
%   delays = sum(AdjacencyMat, 2)' .* bits_in

% in first and second column delays for input and output respectively
delays = n_bits./repmat(sum(Adjacency_mat,2),1,size(n_bits, 2));
return
  
  
  %% Prepare if multipath
if multipath
    U1 = idx; % matrix U in case of fuzzy c means
    k = size(U1,2); % contains both upstream and downstream

    % each round send part of data to just one cluster head
    tmp_idx = zeros(num_+k,1);
        IDX = zeros(num_+k,1);
    tmp_idx(scenario.sink_idx) = 1;
        IDX(scenario.sink_idx) = 1;
        
    %multipath_degree = 3; %how many times replicate data from source
    multipath_degree = min(multipath_options.multipath_degree,k);
    %multipath_type = 3; %how will bandwidth divisioning work (how big piece will each client gain)
    multipath_type = multipath_options.multipath_type;
    if multipath_type == 1
        data_vol1 =            repmat(scenario.data_vol(:,1),1,k).*U1(1:num_,:); % for   upload
        data_vol1 = [data_vol1 repmat(scenario.data_vol(:,2),1,k).*U1(1:num_,:)];% for download
    elseif multipath_type == 2 % divide_per_client
        data_vol1 =            repmat(scenario.data_vol(:,1),1,k).*repmat(1./sum((U1(1:num_,:)>0),2),1,k); % for   upload
        data_vol1 = [data_vol1 repmat(scenario.data_vol(:,2),1,k).*repmat(1./sum((U1(1:num_,:)>0),2),1,k)];% for download
    elseif multipath_type == 3 % repeat data sending to more APs
        [~,U1_I] = sort(U1(1:num_,:),2,'descend');
        topX = zeros(num_,k);
        for i = 1:multipath_degree
            [row,col] = find(U1_I==i);
            sub = sub2ind([num_,k],row,col);
            topX(sub) = 1;
        end
        data_vol1 =            repmat(scenario.data_vol(:,1),1,k).*topX; % for   upload
        data_vol1 = [data_vol1 repmat(scenario.data_vol(:,2),1,k).*topX];% for download
    end
    
    data_delay = 0;
    for k = 1:k
        IDX(tmp_idx==0) = k; % each round send part of data to just one cluster head k
        data = [data_vol1(:,k) data_vol1(:,k+k)];
        data_delay = data_delay + calculate();
    end
else
    data_delay = calculate();
end

%% 
no_sink_no_CH = [1:sink_idx-1,sink_idx+1:num_];
% with_sink_and_CH = [1:num_]; % in case of var. data and max_delay, only ':' is sufficient
temp1 = size(no_sink_no_CH,2);
if up
    trans_type = repmat('upstream',temp1,1);
    up_down = 1;
elseif down
    trans_type = repmat('downstream',temp1,1);
    up_down = 2;
else
    trans_type = repmat('unknown',temp1,1);
    err();
end
% size(data_delay(1:num_))
% size(trans_type)
% size(max_delays(:,up_down))
% size(data)
attended = data_delay(no_sink_no_CH)<=max_delays(no_sink_no_CH,up_down);
att = sum(attended,1);
not_att = size(attended,1)-att;

if show.tables
    T1 = table(node_names(no_sink_no_CH),trans_type,data(no_sink_no_CH,up_down),...
        data_delay(no_sink_no_CH),max_delays(no_sink_no_CH,up_down),attended,...
       'VariableNames',{'IED' 'stream_type' 'bits' 'delay_ms' 'max_delay' 'Att'})

    T2 = table(att,not_att,'VariableNames',{'Attended','Not_Attended'})
end



function data_delay = calculate()
%% caluclate delays
% vectors:  data, tot_rcvd, data_delay
% matrices: bandw
if down Adj = Adj'; end % for downstream, transpose matrix
tot_rcvd = zeros(num,1);
data_delay = zeros(num,1);

% need to increment delay if input flow > highest receiving rate modify
% available data rate according to maximum receivable data rate of nodes
rcv_rate = sum(Adj,1);
f=find(rcv_rate);
% to receive streams from multiple senders, limit sum of receiving rates by
% maximum receiving rate possible (max_rcv_rates)
apply_max_rcv_rate = 0;
if apply_max_rcv_rate
    if stream == 1 %upstream
    Adj(:,f) = min(Adj(:,f),repmat(max_rcv_rates(f)'./rcv_rate(f),num,1).*Adj(:,f));
    else % downstream
        % not implemented yet
        % the restriction needs to be made at the "sender" side
        % because when we make downstream, we simulate it by actually
        % sending bits from clients to sink (simulation by upstream)
    end
end
% while there is data to push (matrix contains nonzero elements)
while nnz(Adj) > 0
	% find leaf node in tree (column 'sender' is all zeros)
	for sender = find(sum(Adj,1)==0)
		% push data to predecessors - at row 'sender'
		s = find(Adj(sender,:)>0);
		total_rate_tmp = sum(Adj(sender,s));
		% for all possible receivers (i.e. for fuzzy c-means)
		for rcvr = s
			% record received data at node
            if total_rate_tmp==Inf
                if Adj(sender,rcvr)==Inf
                    rate = 1/sum(Adj(sender,:)==Inf);
                else
                    rate = 0;
                end
            else
                rate = Adj(sender,rcvr)/total_rate_tmp;
            end
			data_sent_tmp = (data(sender,stream)+tot_rcvd(sender))*rate;
			tot_rcvd(rcvr) = tot_rcvd(rcvr)+ data_sent_tmp;
			% increment delay on this data
			data_delay(sender) = data_delay(sender) + data_sent_tmp/Adj(sender,rcvr);
    end
		% zero out the connection (because it was used)
		Adj(sender,:) = 0;
	end
end

dd = sum(data_delay(1:num_));
% add to data_delay
topo_ord = toposort(G,'Order','stable');
for iter = num:-1:1
    tmp = topo_ord(iter);
    if ~isempty(successors(G,tmp))
        data_delay(tmp) = data_delay(tmp) + max(data_delay(successors(G,tmp))); % max if multipath is used
    end
end
data_delay(find(data(:,stream)==0)) = 0; % those that don't send any data have no own delay

end
end