rem ����˵����
rem �޸� e:/act/home Ϊָ������û��ļ���Ŀ¼��-mtime +7 ��ʾ7��ǰ -type f��ʾ��ͨ�ļ� -exec ��ʾִ�в���, rm ��ɾ������
rem ����������õ�windows��������ִ��
rem ��Ҫ�õ�find.exe rm.exe �붼������windows\system32Ŀ¼��
e:\act\bin\find e:/act/home -mtime +7 -type f -exec rm "{}" ";"