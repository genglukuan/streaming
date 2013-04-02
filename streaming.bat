::�ű����ܣ���Ƶת�롢�з֣�����HTTP Live Streaming�㲥��Ƶ��

::�����ˣ�����
::����ʱ�䣺2013��03��27��

::�޸��ˣ�����
::�޸�ʱ�䣺2013��03��27��

::�汾��v0.1

::�ű��������˵����
::����1����ת�롢�зֵ���Ƶ�ļ�����֧��ȫ·�������·��
::		ȫ·��������E:\�о�����ҵ���-����iOSƽ̨����ý�岥��ϵͳ���о���ʵ��\����\test.avi
::		ע��ȫ·�����ܰ����ո�
::		���·��������.\test.avi��..\dir\test.avi

@ECHO OFF

::���������ӳ�
SETLOCAL ENABLEDELAYEDEXPANSION

CLS
ECHO ��Ƶת�롢�з��Զ����ű�������HTTP Live Streaming�㲥��Ƶ����
ECHO ���ߣ�����
::�������
ECHO.

IF "%1"=="" GOTO :usage
IF "%1"=="/?" GOTO :usage
IF "%1"=="help" GOTO :usage

::������Ƶ�ļ�������ת�롢�зֺ����Ƶ����Ÿ�Ŀ¼
SET rootpathname=%1.stream
IF EXIST "%rootpathname%" RD /S /Q "%rootpathname%"
IF NOT EXIST "%rootpathname%" MD "%rootpathname%"

::������Ƶ�ļ�������ļ�����������·������׺����
CALL :getname "%1"
rem echo %filename%

::ת�����
::��Ƶ������
SET AR=44100
::��Ƶ������
SET AB=128000
::��Ƶ����ֱ���
SET S1=480*224
SET S2=480*224
SET S3=480*224
SET S4=640*360
SET S5=640*360
SET S6=960*540
SET S7=1280*720
SET S8=1280*720
::��Ƶ������
SET B1=110k
SET B2=200k
SET B3=400k
SET B4=600k
SET B5=1200k
SET B6=1800k
SET B7=2500k
SET B8=4500k
::��Ƶ���ݱ�
SET ASPECT=16:9
::�����ⲿת�����ffmpeg
:: ffmpeg����˵����
:: -i "%1"				�����ļ�
:: -f mpegts			�����ʽ
:: -acodec libmp3lame	��Ƶ������
:: -ar	��Ƶ������
:: -ab	��Ƶ������
:: -s	��Ƶ����ֱ���
:: -vcodec libx264		��Ƶ������
:: -b 	��Ƶ������
::		��-b xxxx��ָ����ʹ�ù̶����ʣ��������ģ�1500����ûЧ��
::		�������ö�̬�����磺-qscale 4��-qscale 6��4��������6��
:: -flags +loop
:: -cmp +chroma
:: -partitions +parti4x4+partp8x8+partb8x8
:: -subq 5
:: -trellis 1
:: -refs 1
:: -coder 0
:: -me_range 16
:: -keyint_min 25
:: -sc_threshold 40
:: -i_qfactor 0.71		p֡��i֡qp����
:: -bt		������Ƶ�������̶�kbit/s
:: -maxrate	���������Ƶ�������̶�
:: -bufsize	�������ʿ��ƻ�������С		
:: -rc_eq 'blurCplx^(1-qComp)'	�������ʿ��Ʒ��� Ĭ��tex^qComp
:: -qcomp 0.6			��Ƶ�������ѹ��(VBR)
:: -qmin 10				��С��Ƶ�������(VBR)
:: -qmax 51				�����Ƶ�������(VBR)
:: -qdiff 4				������ȼ����ƫ�� (VBR)
:: -level 30
:: -aspect	��Ƶ���ݱ�
:: -g 30				����ͼ�����С
:: -async 2
:: �����β				����ļ�

SET /A i=1
:loopbody
::!%I%!������ñ���
SET resolution=!S%i%!
SET bitrate=!B%i%!
::������Ƶ�������Ŀ¼
SET childpathname=%rootpathname%\%filename%_%bitrate%
IF EXIST "%childpathname%" RD /S /Q "%childpathname%"
IF NOT EXIST "%childpathname%" MD "%childpathname%"
SET outputfile=%childpathname%\%filename%_%bitrate%_pre.ts
::ת��
ffmpeg -i "%1" -f mpegts -acodec libmp3lame -ar %AR% -ab %AB% -s %resolution% -vcodec libx264 -b %bitrate% -flags +loop -cmp +chroma -partitions +parti4x4+partp8x8+partb8x8 -subq 5 -trellis 1 -refs 1 -coder 0 -me_range 16 -keyint_min 25 -sc_threshold 40 -i_qfactor 0.71 -bt 200k -maxrate %bitrate% -bufsize %bitrate% -rc_eq 'blurCplx^(1-qComp)' -qcomp 0.6 -qmin 10 -qmax 51 -qdiff 4 -level 30 -aspect %ASPECT% -g 30 -async 2 %outputfile%

::�����зֳ�������Ƶ�������Ŀ¼
COPY segmenter.exe %childpathname%\segmenter.exe > NUL
COPY avcodec-52.dll %childpathname%\avcodec-52.dll > NUL
COPY avutil-50.dll %childpathname%\avutil-50.dll > NUL
COPY avformat-52.dll %childpathname%\avformat-52.dll > NUL
::����ű�����stream.bat��ǰĿ¼
SET currentpath=%CD%
::������Ƶ�������Ŀ¼
CD %childpathname%
::�з�
segmenter %filename%_%bitrate%_pre.ts 10 stream_%filename%_%bitrate% %filename%_%bitrate%.m3u8 ""
::ɾ����Ƶ�������Ŀ¼�е��зֳ���
DEL segmenter.exe
DEL avcodec-52.dll
DEL avutil-50.dll
DEL avformat-52.dll
::�лؽű�����stream.bat��ǰĿ¼
CD %currentpath%
::ɾ��ת�����ļ�
DEL %outputfile%
::ѭ����������
SET /A i+=1
::ѭ������8��
IF NOT %i%==9 GOTO :loopbody

::�˳�
::�����ʾ���
ECHO.
ECHO ת�롢�з���ɣ���л����ʹ�ã�
ECHO THX 4 U��BY wwang...
GOTO :exit

:usage
ECHO �����﷨����ȷ
ECHO Usage:streaming.bat [video file name]

:exit
PAUSE

::������Ƶ�ļ�������ļ�����������·������׺����
:getname
SET filename=%~n1