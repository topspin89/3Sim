function [fl_out,Pw,Q,qf]=Chek_bond2(Pw,Ppl,uf,qf,PQ,q)

n=size(Ppl,2)/size(Pw,1); %����� �����
Pw1=repmat(Pw,n,1);
Q=q(:,2)+q(:,1);
uf=sum(reshape(uf,size(uf,1)/n,n),2); uf(uf<0)=-1;uf(uf>0)=1;
PQ(:,3)=0;

fl(:,1)=Pw<PQ(:,1); %�������� �� ����������� ��������
fl(:,2)=Pw>PQ(:,2); %�������� �� ������������ ��������
fl(:,3)=(Q<PQ(:,3)).*(uf==1); %�������� �� ����������� ����� ��������
fl(:,4)=(Q>PQ(:,4)).*(uf==1); %�������� �� ������������ ����� ��������
fl(:,5)=(Q<PQ(:,5)).*(uf==-1); %�������� �� ����������� �������
fl(:,6)=(Q>PQ(:,6)).*(uf==-1); %�������� �� ������������ �������

for i=1:size(uf,1)
    if uf(i)==1 %���� �������� ����������
        if qf(i)==0 %���� �������� ������������ �� ��������
            Q(i)=PQ(i,3)*(fl(i,3)==1)+Q(i)*(fl(i,3)==0);
            Q(i)=PQ(i,4)*(fl(i,4)==1)+Q(i)*(fl(i,4)==0);
            qf(i)=(fl(i,3)+fl(i,4))~=0; %� ������ ���������� ������� ��������� �� �� ������� 
        else %���� �������� ������������ �� �������
            Pw(i)=PQ(i,1)*(fl(i,1)==1)+Pw(i)*(fl(i,1)==0); 
            Pw(i)=PQ(i,2)*(fl(i,2)==1)+Pw(i)*(fl(i,2)==0);
            qf(i)=(fl(i,1)+fl(i,2))==0; %� ������ ���������� ������� ��������� �� �� ��������
        end
    else %���� �������� ��������������
        if qf(i)==0 %���� �������� ������������ �� ��������
            Q(i)=PQ(i,5)*(fl(i,5)==1)+Q(i)*(fl(i,5)==0);
            Q(i)=PQ(i,6)*(fl(i,6)==1)+Q(i)*(fl(i,6)==0);
            qf(i)=(fl(i,5)+fl(i,6))~=0; %� ������ ���������� ������� ��������� �� �� ������� 
        else %���� �������� ������������ �� �������
            Pw(i)=PQ(i,1)*(fl(i,1)==1)+Pw(i)*(fl(i,1)==0);
            Pw(i)=PQ(i,2)*(fl(i,2)==1)+Pw(i)*(fl(i,2)==0); 
            qf(i)=(fl(i,1)+fl(i,2))==0; %� ������ ���������� ������� ��������� �� �� ��������
        end
    end;
end;

fl_out=sum(fl(:))>0;
end
