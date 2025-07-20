DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE news (
	id                int AUTO_INCREMENT
		PRIMARY KEY,
	title             varchar(300) CHARSET utf8mb3       NOT NULL,
	image_preview     text                               NULL,
	short_description text                               NULL,
	description       longtext                           NOT NULL,
	created_at        datetime DEFAULT CURRENT_TIMESTAMP NULL,
	updated_at        datetime DEFAULT CURRENT_TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
	created_by        int                                NULL,
	CONSTRAINT news_users_user_id_fk
		FOREIGN KEY (created_by) REFERENCES users (user_id)
);

INSERT INTO swp_db.news (id, title, image_preview, short_description, description, created_at, updated_at, created_by)
VALUES ( 1, 'Chỉ số loãng xương và những ai nên đo loãng xương?'
       , 'https://www.vinmec.com/static/uploads/large_dau_lung_la_trieu_chung_loang_xuong_can_do_chi_so_loang_xuong_ff053cd458.jpg'
       , 'Chỉ số loãng xương là thước đo quan trọng để phát hiện sớm bệnh lý này, từ đó có thể ngăn ngừa các biến chứng nguy hiểm. Thông thường, loãng xương không có triệu chứng rõ ràng ở giai đoạn đầu nhưng khi tình trạng trở nên nghiêm trọng, xương sẽ yếu đi và dễ gãy. Do đó, việc theo dõi chỉ số loãng xương, đặc biệt ở nhóm người có nguy cơ cao là điều cần thiết để bảo vệ sức khỏe xương.'
       , '<p><strong>B&agrave;i viết n&agrave;y được viết dưới sự hướng dẫn chuy&ecirc;n m&ocirc;n của c&aacute;c b&aacute;c sĩ thuộc khoa Chấn thương chỉnh h&igrave;nh &amp; Y học thể thao Bệnh viện Đa khoa Quốc tế Vinmec.</strong></p>

<h2>1. Lo&atilde;ng xương l&agrave; bệnh g&igrave;?</h2>

<p><a href="https://www.vinmec.com/vie/benh/loang-xuong-3027" target="_blank">Lo&atilde;ng xương</a>&nbsp;l&agrave; một bệnh l&yacute; thường kh&ocirc;ng bộc lộ nhiều triệu chứng cho đến khi t&igrave;nh trạng trở n&ecirc;n nghi&ecirc;m trọng hơn. Bệnh l&agrave;m suy yếu cấu tr&uacute;c v&agrave; giảm khối lượng xương khiến xương trở n&ecirc;n yếu, gi&ograve;n cũng như dễ g&atilde;y. Trong đ&oacute;,&nbsp;<a href="https://www.vinmec.com/vie/bai-viet/gay-xuong-dau-hieu-gay-xuong-va-cach-dieu-tri-vi" target="_blank">g&atilde;y xương</a>&nbsp;ch&iacute;nh l&agrave; hậu quả cuối c&ugrave;ng v&agrave; cũng l&agrave; biến chứng v&ocirc; c&ugrave;ng nghi&ecirc;m trọng của lo&atilde;ng xương.</p>

<p>Trong v&ograve;ng 6 th&aacute;ng đầu sau khi g&atilde;y cổ xương đ&ugrave;i, 20% bệnh nh&acirc;n sẽ tử vong, 50% mất khả năng di chuyển v&agrave; 25% phải cần đến y t&aacute; chăm s&oacute;c tại nh&agrave;, g&acirc;y tốn k&eacute;m chi ph&iacute;.</p>

<p>Trước tuổi 30, cơ thể tạo xương nhanh hơn ph&aacute; hủy xương, gi&uacute;p xương ph&aacute;t triển chắc khỏe v&agrave; đạt được mật độ tối đa. Tuy nhi&ecirc;n, sau tuổi 30, qu&aacute; tr&igrave;nh n&agrave;y chậm lại trong khi qu&aacute; tr&igrave;nh ph&aacute; hủy xương dần chiếm ưu thế. Điều n&agrave;y khiến xương yếu hơn, trở n&ecirc;n mỏng v&agrave; xốp hơn theo thời gian, đặc biệt nếu kh&ocirc;ng được chăm s&oacute;c tốt.</p>

<p><img alt="Tình trạng loãng xương thường ít biểu hiện triệu chứng cho đến khi bệnh trở nên nghiêm trọng hơn." src="https://www.vinmec.com/static/uploads/large_dau_lung_la_trieu_chung_loang_xuong_can_do_chi_so_loang_xuong_ff053cd458.jpg" /></p>

<p>T&igrave;nh trạng lo&atilde;ng xương thường &iacute;t biểu hiện triệu chứng cho đến khi bệnh trở n&ecirc;n nghi&ecirc;m trọng hơn.</p>

<p>Cấu tr&uacute;c v&agrave; khối lượng xương tốt khi c&ograve;n trẻ gi&uacute;p hạn chế nguy cơ lo&atilde;ng xương khi về gi&agrave;. Đồng thời, mật độ xương v&agrave; hoạt động chu chuyển xương c&ograve;n bị t&aacute;c động bởi c&aacute;c yếu tố như hormone nội tiết tố, kho&aacute;ng chất trong xương v&agrave; cytokin.</p>

<p>Do đ&oacute;, khi xương thiếu hụt canxi v&agrave; c&aacute;c kho&aacute;ng chất cần thiết th&igrave; sự ph&aacute;t triển, t&aacute;i tạo xương cũng như mật độ xương sẽ bị ảnh hưởng. Ngo&agrave;i ra, t&igrave;nh trạng suy giảm hormone&nbsp;<a href="https://www.vinmec.com/vie/bai-viet/estrogen-la-gi-va-co-vai-tro-gi-vi" target="_blank">estrogen</a>&nbsp;v&agrave;&nbsp;<a href="https://www.vinmec.com/vie/co-the-nguoi/androgen-47" target="_blank">androgen</a>&nbsp;cũng l&agrave; một yếu tố khiến qu&aacute; tr&igrave;nh mất xương diễn ra nhanh hơn. V&igrave; l&yacute; do n&agrave;y, phụ nữ m&atilde;n kinh sớm v&agrave; nam giới bị thiểu năng sinh dục thường c&oacute; nguy cơ cao đối mặt với t&igrave;nh trạng lo&atilde;ng xương.</p>

<p>T&igrave;nh trạng lo&atilde;ng xương trong cộng đồng ng&agrave;y nay c&oacute; tỷ lệ kh&aacute; cao. Ở nh&oacute;m phụ nữ tr&ecirc;n 50 tuổi, cứ 3 người th&igrave; c&oacute; 1 người mắc. Trong khi đ&oacute; ở nam giới tỷ lệ l&agrave; 1/10.</p>

<p>Ch&iacute;nh v&igrave; những biến chứng nghi&ecirc;m trọng m&agrave; việc sớm&nbsp;<a href="https://www.vinmec.com/vie/bai-viet/dieu-tri-loang-xuong-the-nao-vi" target="_blank">ph&aacute;t hiện v&agrave; điều trị lo&atilde;ng xương</a>&nbsp;trở n&ecirc;n v&ocirc; c&ugrave;ng quan trọng. Do đ&oacute;, kh&ocirc;ng &iacute;t người quan t&acirc;m đến chỉ số lo&atilde;ng xương l&agrave; bao nhi&ecirc;u.</p>

<p><img alt="Phụ nữ trên 50 tuổi có tỷ lệ bị loãng xương khá cao, với cứ 3 người thì có 1 người mắc." src="https://www.vinmec.com/static/uploads/large_phu_nu_nen_do_chi_so_loang_xuong_boi_co_ty_le_mac_cao_1_5b40d0c8db.jpg" /></p>

<p>Phụ nữ tr&ecirc;n 50 tuổi c&oacute; tỷ lệ bị lo&atilde;ng xương kh&aacute; cao, với cứ 3 người th&igrave; c&oacute; 1 người mắc.</p>

<h2>2. Chỉ số lo&atilde;ng xương l&agrave; bao nhi&ecirc;u?</h2>

<p>B&aacute;c sĩ thường chỉ định đo mật độ xương th&ocirc;ng qua T-score v&agrave; Z-score để x&aacute;c định nguy cơ lo&atilde;ng xương. Dựa tr&ecirc;n ti&ecirc;u chuẩn chẩn đo&aacute;n của Tổ chức Y tế Thế giới (WHO) năm 1994, mật độ xương sẽ được đo tại cổ xương đ&ugrave;i v&agrave; cột sống thắt lưng bằng phương ph&aacute;p DXA.</p>

<p>Đối với chỉ số T-score:</p>

<p>&nbsp;</p>

<ul>
	<li>T-score từ -1 SD trở l&ecirc;n đồng nghĩa với việc mật độ xương ở trạng th&aacute;i b&igrave;nh thường v&agrave; kh&ocirc;ng c&oacute; t&igrave;nh trạng lo&atilde;ng xương.</li>
	<li>T-score từ -1 SD đến -2.5 SD cho thấy t&igrave;nh trạng thiếu xương.</li>
	<li>T-score dưới -2.5 SD l&agrave; chỉ số b&aacute;o hiệu t&igrave;nh trạng lo&atilde;ng xương.</li>
	<li>Khi T-score thấp hơn -2.5 SD v&agrave; người bệnh c&oacute; tiền sử hoặc hiện tại bị g&atilde;y xương th&igrave; đồng nghĩa với việc đang gặp t&igrave;nh trạng lo&atilde;ng xương nặng.</li>
</ul>

<p>Chỉ số Z-score l&agrave; một thước đo quan trọng để so s&aacute;nh mật độ xương của người được đo với mật độ xương trung b&igrave;nh của những người khỏe mạnh c&oacute; c&ugrave;ng độ tuổi, giới t&iacute;nh, chiều cao, c&acirc;n nặng v&agrave; chủng tộc, gi&uacute;p đ&aacute;nh gi&aacute; t&igrave;nh trạng xương một c&aacute;ch ch&iacute;nh x&aacute;c hơn.</p>

<p>Đối với chỉ số Z-score:</p>

<ul>
	<li>Z-score = 0: Mật độ xương đang bằng với gi&aacute; trị trung b&igrave;nh của độ tuổi.</li>
	<li>Z-score &gt; 0: Mật độ xương đang cao hơn gi&aacute; trị trung b&igrave;nh của độ tuổi.</li>
	<li>Z-score &lt; 0: Mật độ xương đang thấp hơn gi&aacute; trị trung b&igrave;nh của độ tuổi.</li>
	<li>Z-score dưới -1.5 y&ecirc;u cầu sự can thiệp của chuy&ecirc;n gia để chẩn đo&aacute;n v&agrave; x&aacute;c định liệu c&oacute; bệnh l&yacute; thứ ph&aacute;t n&agrave;o g&acirc;y mất xương.</li>
	<li>Khi Z-score dưới -2.0 k&egrave;m theo t&igrave;nh trạng g&atilde;y xương hoặc c&oacute; tiền sử g&atilde;y xương th&igrave; sẽ được chẩn đo&aacute;n l&agrave; lo&atilde;ng xương.</li>
</ul>

<h2>3. Những ai n&ecirc;n đo chỉ số lo&atilde;ng xương?</h2>

<p><a href="https://www.vinmec.com/vie/bai-viet/cac-phuong-phap-do-mat-do-xuong-de-phat-hien-nguy-co-loang-xuong-vi" target="_blank">Đo mật độ xương</a>&nbsp;l&agrave; phương ph&aacute;p gi&uacute;p ph&aacute;t hiện sớm t&igrave;nh trạng lo&atilde;ng xương v&agrave; mất xương, từ đ&oacute; c&oacute; thể &aacute;p dụng c&aacute;c biện ph&aacute;p ph&ograve;ng ngừa cũng như điều trị kịp thời, hạn chế nguy cơ biến chứng nghi&ecirc;m trọng.</p>

<p><img alt="Người cao tuổi nên thực hiện đo chỉ số loãng xương." src="https://www.vinmec.com/static/uploads/large_nguoi_gia_nen_do_chi_so_loang_xuong_4d83be0ec6.jpg" /></p>

<p>Người cao tuổi n&ecirc;n thực hiện đo chỉ số lo&atilde;ng xương.</p>

<p>Ch&iacute;nh v&igrave; vậy, việc đo chỉ số lo&atilde;ng xương rất quan trọng. Để gi&uacute;p ph&aacute;t hiện v&agrave; chẩn đo&aacute;n sớm c&aacute;c bệnh l&yacute;, ch&uacute;ng ta cần thực hiện kh&aacute;m sức khỏe định kỳ. B&ecirc;n cạnh đ&oacute;, b&aacute;c sĩ sẽ chỉ định đo mật độ xương trong một số t&igrave;nh huống đặc biệt như:</p>

<ul>
	<li>Người cao tuổi, đặc biệt l&agrave; tr&ecirc;n 65 tuổi.</li>
	<li>Phụ nữ sau thời kỳ m&atilde;n kinh từ độ tuổi 45 - 50 v&agrave; người bị m&atilde;n kinh sớm.</li>
	<li>Những người c&oacute; xương nhỏ cũng c&oacute; nguy cơ cao bị lo&atilde;ng xương, v&igrave; vậy cần thực hiện đo mật độ xương định kỳ.</li>
	<li>Người bị c&aacute;c bệnh l&yacute; như thiểu năng tuyến sinh dục, cường gi&aacute;p tiến triển, cường vỏ thượng thận v&agrave; cường gi&aacute;p ti&ecirc;n ph&aacute;t.</li>
	<li>Những người c&oacute; lối sống kh&ocirc;ng l&agrave;nh mạnh, &iacute;t vận động, nghiện rượu, h&uacute;t thuốc hoặc thiếu&nbsp;<a href="https://www.vinmec.com/vie/co-the-nguoi/canxi-43" target="_blank">canxi</a>&nbsp;v&agrave;&nbsp;<a href="https://www.vinmec.com/vie/bai-viet/vitamin-d-cong-dung-lieu-dung-tac-dung-phu-vi" target="_blank">vitamin D</a>&nbsp;trong chế độ ăn.</li>
	<li>Người đ&atilde; phẫu thuật xương khớp.</li>
	<li>Mắc bệnh m&atilde;n t&iacute;nh v&agrave; đang sử dụng c&aacute;c loại thuốc c&oacute; t&aacute;c dụng phụ l&agrave;m tổn hại đến xương, dẫn đến lo&atilde;ng xương thứ cấp như thuốc điều trị rối loạn nội tiết, thuốc chữa rối loạn collagen, thuốc điều trị suy tủy&hellip;</li>
</ul>

<p><img alt="Mọi người nên đi đo chỉ số loãng xương định kỳ để sớm phát hiện tình trạng bệnh." src="https://www.vinmec.com/static/uploads/large_nguoi_benh_nen_di_gap_bac_si_de_hieu_hon_ve_tinh_trang_benh_a981998b9f.jpg" /></p>

<p>Mọi người n&ecirc;n đi đo chỉ số lo&atilde;ng xương định kỳ để sớm ph&aacute;t hiện t&igrave;nh trạng bệnh.</p>

<p>Nh&igrave;n chung, việc ph&aacute;t hiện v&agrave; điều trị sớm lo&atilde;ng xương rất quan trọng trong việc giảm thiểu nguy cơ g&atilde;y xương v&agrave; c&aacute;c biến chứng nghi&ecirc;m trọng. Do đ&oacute;, đo mật độ xương định kỳ v&agrave; duy tr&igrave; lối sống l&agrave;nh mạnh l&agrave; cần thiết, gi&uacute;p bảo vệ sức khỏe xương, n&acirc;ng cao chất lượng cuộc sống cũng như ph&ograve;ng ngừa c&aacute;c bệnh l&yacute; li&ecirc;n quan.</p>
', '2025-07-14 13:00:24', '2025-07-19 14:11:40', 4);
INSERT INTO swp_db.news (id, title, image_preview, short_description, description, created_at, updated_at, created_by)
VALUES ( 2, 'Viêm cơ, áp xe cơ: Nguyên nhân, triệu chứng, chẩn đoán và điều trị'
       , 'https://www.vinmec.com/static/uploads/20191230_092803_722036_viem_co_can_max_1800x1800_jpg_cd3d93fa27.jpg'
       , 'Viêm cơ, áp xe cơ nhiễm khuẩn là tổn thương viêm hoặc áp xe tại cơ vân do vi khuẩn gây nên. Bệnh thường khởi phát khi có các vết thương ở da gây viêm nhiễm, sau khi thực hiện các thủ thuật trên da không được đảm bảo vệ sinh, vô khuẩn.'
       , '<h2>Nguy&ecirc;n nh&acirc;n bệnh Vi&ecirc;m cơ, &aacute;p xe cơ</h2>

<p>&nbsp;</p>

<p>Nguy&ecirc;n nh&acirc;n ch&iacute;nh g&acirc;y ra vi&ecirc;m cơ, &aacute;p xe cơ l&agrave; do sự x&acirc;m nhập của vi khuẩn v&agrave;o cơ v&acirc;n th&ocirc;ng qua c&aacute;c vết r&aacute;ch hoặc trầy xước tr&ecirc;n da kh&ocirc;ng được vệ sinh sạch sẽ. Người bệnh c&oacute; thể bị nhiễm khi c&aacute;c vết trầy xước tiếp x&uacute;c với vi khuẩn trong điều kiện &ocirc; nhiễm, với c&aacute;c dụng cụ mất vệ sinh.</p>

<p>Ngo&agrave;i ra, việc thực hiện thủ thuật như ti&ecirc;m truyền, ch&acirc;m cứu, phẫu thuật khi chưa được s&aacute;t khuẩn da kỹ c&agrave;ng, dụng cụ kh&ocirc;ng đảm bảo v&ocirc; tr&ugrave;ng, tiệt tr&ugrave;ng khi can thiệp tr&ecirc;n da đ&atilde; l&agrave;m cho vi khuẩn c&oacute; đường x&acirc;m nhập ho&agrave;n hảo v&agrave; b&ecirc;n trong cơ g&acirc;y n&ecirc;n c&aacute;c vi&ecirc;m cơ v&agrave; &aacute;p xe.</p>

<h2>Triệu chứng bệnh Vi&ecirc;m cơ, &aacute;p xe cơ</h2>

<p>&nbsp;</p>

<p>Vi&ecirc;m cơ, &aacute;p xe cơ c&oacute; thể xuất hiện tại bất kỳ vị tr&iacute; n&agrave;o của cơ thể. Tr&ecirc;n c&aacute;c bệnh nh&acirc;n mắc c&aacute;c hội chứng suy giảm miễn dịch, vi&ecirc;m cơ &aacute;p xe cơ c&oacute; thể xuất hiện tại nhiều cơ tr&ecirc;n cơ thể.</p>

<p>C&aacute;c triệu chứng xuất hiện khi vi&ecirc;m cơ, &aacute;p xe cơ gồm c&oacute;: Sưng cơ, đau cơ, tấy đỏ. Thời gian sau đ&oacute; nếu kh&ocirc;ng được điều trị, diễn biến bệnh sẽ tăng l&ecirc;n với cảm gi&aacute;c rất đau, căng tức khi ấn xuống, chọc h&uacute;t ra mủ. Nếu để l&acirc;u hơn bệnh sẽ diễn biến nặng l&ecirc;n g&acirc;y vi&ecirc;m c&aacute;c khớp l&acirc;n cận, bệnh nh&acirc;n sốt cao, sốt li&ecirc;n tục, &yacute; thức thay đổi, c&oacute; thể dẫn đến nhiễm khuẩn huyết g&acirc;y ảnh hưởng đến t&iacute;nh mạng.</p>

<p><img alt="
Viêm cơ cắn
" src="https://www.vinmec.com/static/uploads/20191230_092803_722036_viem_co_can_max_1800x1800_jpg_cd3d93fa27.jpg" /></p>

<p>Vi&ecirc;m cơ cắn</p>

<h2>Đối tượng nguy cơ bệnh Vi&ecirc;m cơ, &aacute;p xe cơ</h2>

<p>&nbsp;</p>

<p>Vi&ecirc;m cơ, &aacute;p xe gặp ở mọi đối tượng kh&ocirc;ng ph&acirc;n biệt độ tuổi. Bệnh hay gặp nhất ở những người c&oacute; hệ thống miễn dịch bị suy giảm như trong bệnh HIV, c&aacute;c&nbsp;<a href="https://www.vinmec.com/vie/bai-viet/cach-tang-cuong-mien-dich-cho-nguoi-mac-benh-tu-mien-vi"><strong>bệnh tự miễn</strong></a>&nbsp;như lupus ban đỏ hệ thống, đ&aacute;i th&aacute;o đường, vi&ecirc;m đa cơ hệ thống, xơ cứng b&igrave;, c&aacute;c trường hợp sử dụng c&aacute;c loại thuốc ức chế miễn dịch k&eacute;o d&agrave;i trong điều trị bệnh.</p>

<p>Người gi&agrave;, trẻ em, những đối tượng suy dinh dưỡng, cơ thể suy kiệt, mắc c&aacute;c bệnh c&aacute;c t&iacute;nh, những người l&agrave;m việc trong m&ocirc;i trường độc hại l&agrave; một trong những người dễ mắc bệnh nhất.</p>

<h2>Ph&ograve;ng ngừa bệnh Vi&ecirc;m cơ, &aacute;p xe cơ</h2>

<p>&nbsp;</p>

<p>Ăn uống đầy đủ chất dinh dưỡng, tập thể dục thường xuy&ecirc;n, kh&ocirc;ng sử dụng rượu bia v&agrave; h&uacute;t thuốc l&aacute; nhằm n&acirc;ng cao hệ thống miễn dịch của cơ thể. Khi c&oacute; c&aacute;c vết thương tr&ecirc;n da cần vệ sinh sạch sẽ, đảm bảo v&ocirc; tr&ugrave;ng khi thực hiện c&aacute;c thủ thuật can thiệp. Điều trị t&iacute;ch cực c&aacute;c bệnh l&yacute; tự miễn của cơ thể như đ&aacute;i th&aacute;o đường, lupus ban đỏ hệ thống. Khi xuất hiện c&aacute;c triệu chứng cần đến kh&aacute;m tại cơ sở y tế khi c&oacute; biện ph&aacute;p điều trị ph&ugrave; hợp, kh&ocirc;ng để bệnh diễn biến nặng sẽ kh&oacute; khăn trong việc điều trị.</p>

<p><img alt="
Viêm cơ vai
" src="https://www.vinmec.com/static/uploads/large_20191218_021902_375796_co_ba_vai_max_1800x1800_jpeg_f092e9ded6.jpg" /></p>

<p>Vi&ecirc;m cơ vai</p>

<h2>C&aacute;c biện ph&aacute;p chẩn đo&aacute;n bệnh Vi&ecirc;m cơ, &aacute;p xe cơ</h2>

<p>&nbsp;</p>

<p>Khi người bệnh đến kh&aacute;m chuy&ecirc;n khoa, b&aacute;c sĩ sẽ kết hợp giữa biểu hiện l&acirc;m s&agrave;ng của người bệnh v&agrave; hỏi bệnh như thời gian đau, t&igrave;nh trạng, vị tr&iacute; đau x&aacute;c định bệnh. Sau đ&oacute;, b&aacute;c sĩ sẽ hướng dẫn người bệnh thực hiện c&aacute;c x&eacute;t nghiệm chuy&ecirc;n khoa như:</p>

<ul>
	<li>X&eacute;t nghiệm m&aacute;u kiểm tra trong trường hợp vi&ecirc;m như c&ocirc;ng thức m&aacute;u, định lượng CRP, Fibrinogen, m&aacute;u lắng. Kiểm tra cấy m&aacute;u t&igrave;m vi khuẩn hoặc chọc h&uacute;t tại vị tr&iacute; vi&ecirc;m, &aacute;p xe t&igrave;m vi khuẩn để x&aacute;c định nguy&ecirc;n nh&acirc;n v&agrave; điều trị ph&ugrave; hợp.</li>
	<li>Kiểm tra bằng kỹ thuật chẩn đo&aacute;n h&igrave;nh ảnh mang lại gi&aacute; trị cao như si&ecirc;u &acirc;m cơ t&igrave;m tổn thương v&agrave; đ&aacute;nh gi&aacute; mức độ tổn thương, chụp cắt lớp vi t&iacute;nh x&aacute;c định tổn thương đồng thời x&aacute;c định mức độ x&acirc;m lấn của tổn thương gi&uacute;p cho b&aacute;c sĩ thấy r&otilde; được c&aacute;c h&igrave;nh ảnh tổn thương xương, m&ocirc; mềm đồng thời đ&aacute;nh gi&aacute; được mức độ tổn thương để c&oacute; phương ph&aacute;p điều trị ph&ugrave; hợp nhất.</li>
</ul>

<h2>C&aacute;c biện ph&aacute;p điều trị bệnh Vi&ecirc;m cơ, &aacute;p xe cơ</h2>

<p>&nbsp;</p>

<p>Việc ph&aacute;t hiện v&agrave; điều trị bệnh vi&ecirc;m cơ, &aacute;p xe cơ rất quan trọng, cần thực hiện theo chỉ định của b&aacute;c sĩ. Tuyệt nhi&ecirc;n kh&ocirc;ng để bệnh l&acirc;u, bệnh diễn biến xấu sẽ g&acirc;y hậu quả nghi&ecirc;m trọng. C&aacute;c biện ph&aacute;p điều trị hiện nay thường sử dụng như:</p>

<ul>
	<li>Điều trị nội khoa theo chỉ định của b&aacute;c sĩ: Điều trị bằng kh&aacute;ng sinh theo chỉ định. Tuyệt đối chỉ được d&ugrave;ng kh&aacute;ng sinh theo chỉ định của b&aacute;c sĩ sau khi c&oacute; kết quả x&eacute;t nghiệm. Việc d&ugrave;ng thuốc bừa b&atilde;i kh&ocirc;ng những kh&ocirc;ng điều trị được bệnh m&agrave; c&ograve;n tăng nguy cơ vi khuẩn kh&aacute;ng thuốc l&agrave;m thất bại trong việc điều trị.</li>
	<li>Điều trị n&acirc;ng cao thể trạng cho người bệnh, tăng cường khả năng miễn dịch gi&uacute;p tăng khả năng điều trị của người bệnh.</li>
	<li>Trong qu&aacute; tr&igrave;nh điều trị cần kiểm tra thường xuy&ecirc;n nhằm đ&aacute;nh gi&aacute; khả năng phục hồi v&agrave; tiến triển bệnh để c&oacute; phương &aacute;n điều trị ph&ugrave; hợp.</li>
</ul>
', '2025-07-14 14:00:25', '2025-07-19 14:11:40', 4);
INSERT INTO swp_db.news (id, title, image_preview, short_description, description, created_at, updated_at, created_by)
VALUES ( 3, 'Viêm khớp: Nguyên nhân, triệu chứng, chẩn đoán và điều trị'
       , 'https://tamanhhospital.vn/wp-content/uploads/2021/05/benh-viem-khop-1.jpg'
       , 'Mục tiêu chính của điều trị viêm khớp là giảm đau, giúp khôi phục khả năng vận động của khớp và tránh khớp bị tổn thương thêm. Các phương pháp điều trị nội khoa, ngoại khoa kết hợp cùng duy trì lối sống lành mạnh và chế độ ăn uống cân đối sẽ giúp kiểm soát và giảm triệu chứng bệnh tốt hơn.'
       , '<p><strong>B&agrave;i viết n&agrave;y được viết dưới sự hướng dẫn chuy&ecirc;n m&ocirc;n của c&aacute;c b&aacute;c sĩ thuộc khoa Chấn thương chỉnh h&igrave;nh &amp; Y học thể thao Bệnh viện Đa khoa Quốc tế Vinmec.</strong></p>

<h2>1. Tổng quan về bệnh Vi&ecirc;m khớp</h2>

<p>C&oacute; khoảng 100 loại bệnh vi&ecirc;m khớp, bao gồm cả vi&ecirc;m khớp đơn thuần v&agrave; vi&ecirc;m khớp ảnh hưởng đến c&aacute;c cơ quan kh&aacute;c. Hai loại vi&ecirc;m khớp phổ biến nhất l&agrave; vi&ecirc;m xương khớp (OA) v&agrave; vi&ecirc;m khớp dạng thấp (RA).</p>

<p>Vi&ecirc;m xương khớp (OA) l&agrave; loại&nbsp;<a href="https://www.vinmec.com/vie/bai-viet/viem-khop-nguyen-nhan-trieu-chung-chan-doan-va-dieu-tri-vi" target="_blank">vi&ecirc;m khớp</a>&nbsp;phổ biến nhất, t&aacute;c động chủ yếu đến sụn khớp - m&ocirc; bao phủ c&aacute;c đầu xương gi&uacute;p giảm ma s&aacute;t v&agrave; đảm bảo đầu xương di chuyển dễ d&agrave;ng trong khớp. &nbsp;</p>

<p>Vi&ecirc;m xương khớp g&acirc;y ra sự hạn chế trong việc di chuyển v&agrave; c&oacute; thể l&agrave;m biến dạng khớp, thậm ch&iacute; l&agrave; lệch xương khỏi vị tr&iacute; b&igrave;nh thường. C&aacute;c khớp thường bị ảnh hưởng l&agrave; c&aacute;c khớp ở tay, cột sống, đầu gối v&agrave; h&ocirc;ng. Bệnh thường xuất hiện ở lứa tuổi trung ni&ecirc;n, nhất l&agrave; với người sau tuổi 40. Tuy nhi&ecirc;n, vi&ecirc;m xương khớp cũng c&oacute; thể xuất hiện ở người trẻ, đặc biệt l&agrave; sau c&aacute;c chấn thương khớp.</p>

<p>Vi&ecirc;m khớp dạng thấp (RA) l&agrave; một bệnh li&ecirc;n quan đến hệ thống miễn dịch, tấn c&ocirc;ng c&aacute;c m&agrave;ng hoạt dịch v&agrave; g&acirc;y rối loạn trong khớp. Phụ nữ tr&ecirc;n 40 tuổi thường l&agrave; đối tượng chủ yếu mắc bệnh v&agrave; cần&nbsp;<strong>điều trị vi&ecirc;m khớp</strong>.</p>

<h2>2. C&aacute;c loại bệnh cần điều trị vi&ecirc;m khớp</h2>

<p>Trong hơn 100 loại bệnh vi&ecirc;m khớp, những loại phổ biến thường gặp nhất bao gồm:</p>

<h3>2.1 Vi&ecirc;m khớp dạng thấp</h3>

<p>Đ&acirc;y l&agrave; một trong những bệnh tự miễn phổ biến v&agrave; g&acirc;y phiền to&aacute;i cho nhiều người nhất. Căn bệnh n&agrave;y xảy ra khi hệ thống miễn dịch tấn c&ocirc;ng c&aacute;c m&ocirc; trong cơ thể, đặc biệt l&agrave; m&ocirc; li&ecirc;n kết. Kết quả l&agrave; khớp bị tổn thương, dẫn đến vi&ecirc;m v&agrave; g&acirc;y ra t&igrave;nh trạng đau, tho&aacute;i h&oacute;a m&ocirc; khớp, cần phải điều trị vi&ecirc;m khớp.</p>

<p>So với tổn thương do tho&aacute;i h&oacute;a khớp g&acirc;y ra, vi&ecirc;m khớp dạng thấp ảnh hưởng đến ni&ecirc;m mạc khớp, g&acirc;y sưng đau, v&agrave; cuối c&ugrave;ng dẫn đến x&oacute;i m&ograve;n xương v&agrave; biến dạng khớp.</p>

<p>Bệnh n&agrave;y kh&ocirc;ng chỉ ảnh hưởng đến khớp m&agrave; c&ograve;n k&eacute;o theo một loạt c&aacute;c cơ quan kh&aacute;c bị tổn thương, như mắt, da, phổi, v&agrave; mạch m&aacute;u. C&oacute; một số yếu tố được xem l&agrave; g&oacute;p phần v&agrave;o sự ph&aacute;t triển của căn bệnh n&agrave;y:</p>

<ul>
	<li>Phụ nữ c&oacute; nguy cơ mắc bệnh cao hơn nam giới.</li>
	<li>Bệnh c&oacute; thể tấn c&ocirc;ng ở mọi lứa tuổi, nhưng thường gặp nhiều ở tuổi trung ni&ecirc;n.</li>
	<li>Tiền sử gia đ&igrave;nh c&oacute; th&agrave;nh vi&ecirc;n bị vi&ecirc;m khớp dạng thấp cũng tăng nguy cơ mắc bệnh v&agrave; cần phải điều trị vi&ecirc;m khớp kịp thời.</li>
	<li>H&uacute;t thuốc l&aacute; kh&ocirc;ng chỉ l&agrave;m tăng nguy cơ ph&aacute;t triển bệnh m&agrave; c&ograve;n l&agrave;m cho c&aacute;c triệu chứng trở n&ecirc;n nặng nề hơn.</li>
	<li>Tiếp x&uacute;c với m&ocirc;i trường chứa h&oacute;a chất như amiăng, silica cũng l&agrave; một trong những yếu tố khiến bệnh ph&aacute;t triển.</li>
	<li>Thừa c&acirc;n v&agrave; b&eacute;o ph&igrave;, đặc biệt l&agrave; ở phụ nữ tr&ecirc;n 55 tuổi, c&oacute; chỉ số&nbsp;<a href="https://www.vinmec.com/vie/bai-viet/chi-so-bmi-bao-nhieu-la-binh-thuong-vi" target="_blank">BMI</a>&nbsp;&gt; 23.</li>
</ul>

<h3>2.2 Tho&aacute;i h&oacute;a khớp</h3>

<p>Bệnh&nbsp;<a href="https://www.vinmec.com/vie/bai-viet/thoai-hoa-khop-goi-vi" target="_blank">tho&aacute;i h&oacute;a khớp</a>&nbsp;l&agrave; một t&igrave;nh trạng cần điều trị vi&ecirc;m khớp phổ biến, ảnh hưởng đến sụn, ni&ecirc;m mạc khớp, d&acirc;y chằng v&agrave; xương dưới khớp. Căn bệnh n&agrave;y xuất hiện khi lớp sụn bảo vệ c&aacute;c đầu xương bị m&ograve;n theo thời gian, cuối c&ugrave;ng dẫn đến cảm gi&aacute;c đau v&agrave; cứng khớp.</p>

<p>Những khớp phải hoạt động nhiều như h&ocirc;ng, đầu gối, cột sống, b&agrave;n tay, khớp ng&oacute;n c&aacute;i v&agrave; ng&oacute;n ch&acirc;n c&aacute;i l&agrave; những khớp dễ bị tho&aacute;i ho&aacute;. &nbsp;</p>

<p>Yếu tố l&agrave;m tăng nguy cơ bệnh tho&aacute;i h&oacute;a khớp bao gồm:</p>

<ul>
	<li>Tuổi t&aacute;c: Người c&agrave;ng lớn tuổi c&oacute; nguy cơ mắc bệnh c&agrave;ng cao.</li>
	<li>Giới t&iacute;nh: Nam giới &iacute;t c&oacute; khả năng mắc bệnh tho&aacute;i h&oacute;a khớp hơn so với phụ nữ.</li>
	<li>Thừa c&acirc;n &ndash; b&eacute;o ph&igrave;: Chỉ số BMI cao sẽ tăng th&ecirc;m nguy cơ phải điều trị vi&ecirc;m khớp về l&acirc;u d&agrave;i.</li>
	<li>Tổn thương khớp: Chấn thương từ hoạt động thể chất hoặc tai nạn c&oacute; thể l&agrave;m tăng nguy cơ mắc bệnh v&agrave; cần điều trị vi&ecirc;m khớp từ sớm.</li>
	<li>Yếu tố di truyền: Một số người c&oacute; tiền sử gia đ&igrave;nh về bệnh tho&aacute;i h&oacute;a khớp.</li>
	<li>Dị dạng xương: Những người bị sụn khiếm khuyết hoặc khớp bị dị dạng c&oacute; nguy cơ cao hơn bị tho&aacute;i h&oacute;a khớp.</li>
</ul>

<h3>2.3 Vi&ecirc;m khớp nhiễm khuẩn</h3>

<p><a href="https://www.vinmec.com/vie/bai-viet/the-nao-la-viem-khop-nhiem-khuan-vi#:~:text=Vi%C3%AAm%20kh%E1%BB%9Bp%20nhi%E1%BB%85m%20khu%E1%BA%A9n%20l%C3%A0%20t%C3%ACnh%20tr%E1%BA%A1ng%20nhi%E1%BB%85m%20tr%C3%B9ng%20b%C3%AAn,ph%E1%BA%ADn%20kh%C3%A1c%20c%E1%BB%A7a%20c%C6%A1%20th%E1%BB%83." target="_blank">Vi&ecirc;m khớp nhiễm khuẩn</a>&nbsp;l&agrave; t&igrave;nh trạng khi c&aacute;c khớp bị vi&ecirc;m do nhiễm vi khuẩn hoặc nấm. C&aacute;c khớp thường chịu ảnh hưởng nhất l&agrave; khớp đầu gối v&agrave; h&ocirc;ng.</p>

<p>Bệnh c&oacute; thể ph&aacute;t triển khi vi khuẩn hoặc vi sinh vật g&acirc;y bệnh lan qua m&aacute;u đến khớp. Cũng c&oacute; trường hợp khớp bị nhiễm trực tiếp bởi vi sinh vật sau chấn thương hoặc phẫu thuật.</p>

<p>C&aacute;c loại vi khuẩn như Staphylococcus, Streptococcus, Neisseria gonorrhoeae... thường g&acirc;y vi&ecirc;m ở khớp do nhiễm khuẩn cấp t&iacute;nh. Trong khi đ&oacute;, vi khuẩn Mycobacterium tuberculosis, Candida albicans g&acirc;y n&ecirc;n vi&ecirc;m khớp nhiễm khuẩn mạn t&iacute;nh.</p>

<p>C&aacute;c yếu tố tăng nguy cơ cần&nbsp;<strong>điều trị vi&ecirc;m khớp</strong>&nbsp;do vi&ecirc;m khớp nhiễm khuẩn bao gồm:</p>

<ul>
	<li>C&aacute;c bệnh l&yacute; hoặc tổn thương kh&aacute;c ở khớp.</li>
	<li>Người từng cấy gh&eacute;p khớp nh&acirc;n tạo.</li>
	<li>Nhiễm vi khuẩn ở c&aacute;c bộ phận kh&aacute;c trong cơ thể.</li>
	<li>Sự hiện diện của vi khuẩn trong m&aacute;u.</li>
	<li>C&aacute;c bệnh mạn t&iacute;nh (như đ&aacute;i th&aacute;o đường, bệnh hồng cầu h&igrave;nh liềm, vi&ecirc;m khớp dạng thấp, bệnh hồng cầu h&igrave;nh liềm...).</li>
	<li>Ti&ecirc;m tĩnh mạch (IV) hoặc ti&ecirc;m ch&iacute;ch ma t&uacute;y.</li>
	<li>Sử dụng c&aacute;c loại thuốc ức chế hệ thống miễn dịch.</li>
	<li>C&aacute;c t&igrave;nh trạng l&agrave;m suy yếu hệ thống miễn dịch như HIV.</li>
</ul>

<h3>2.4 Vi&ecirc;m khớp phản ứng</h3>

<p>Đ&acirc;y l&agrave; một bệnh l&yacute; kh&ocirc;ng đe dọa t&iacute;nh mạng, nhưng g&acirc;y sưng v&agrave; đau ở c&aacute;c khớp do nhiễm tr&ugrave;ng từ một bộ phận kh&aacute;c của cơ thể, thường l&agrave; c&aacute;c bộ phận như ruột, bộ phận sinh dục, đường tiết niệu.</p>

<p>Khi mắc phải vi&ecirc;m khớp phản ứng, c&aacute;c v&ugrave;ng như đầu gối, khớp cổ ch&acirc;n v&agrave; b&agrave;n ch&acirc;n thường bị ảnh hưởng nhiều nhất. Ngo&agrave;i ra, t&igrave;nh trạng vi&ecirc;m c&ograve;n c&oacute; thể ảnh hưởng đến mắt, da v&agrave; niệu đạo.</p>

<p>Ti&ecirc;n lượng của căn bệnh n&agrave;y rất khả quan khi so với c&aacute;c loại vi&ecirc;m khớp kh&aacute;c. Nếu bệnh nh&acirc;n được điều trị vi&ecirc;m khớp phản ứng theo đ&uacute;ng ph&aacute;c đồ, c&aacute;c triệu chứng sẽ biến mất trong khoảng 12 th&aacute;ng.</p>

<p>Nếu c&oacute; một trong những yếu tố rủi ro dưới đ&acirc;y, bệnh nh&acirc;n c&oacute; nguy cơ cao cần điều trị vi&ecirc;m khớp phản ứng:</p>

<ul>
	<li>Tuổi t&aacute;c: Bệnh phổ biến nhất ở nh&oacute;m tuổi từ 20 đến 40.</li>
	<li>Giới t&iacute;nh: Phụ nữ v&agrave; nam giới c&oacute; nguy cơ bị vi&ecirc;m khớp phản ứng như nhau nếu nhiễm tr&ugrave;ng xuất ph&aacute;t từ thức ăn. Tuy nhi&ecirc;n, nam giới c&oacute; khả năng mắc bệnh từ vi khuẩn l&acirc;y truyền qua đường t&igrave;nh dục nhiều hơn so với phụ nữ.</li>
	<li>Di truyền.</li>
</ul>

<h3>2.5 Vi&ecirc;m cột sống d&iacute;nh khớp</h3>

<p>Vi&ecirc;m cột sống d&iacute;nh khớp l&agrave; một t&igrave;nh trạng vi&ecirc;m, khiến cho một số xương nhỏ trong cột sống li&ecirc;n kết với nhau. Qu&aacute; tr&igrave;nh n&agrave;y l&agrave;m cho cột sống mất đi sự linh hoạt, dẫn đến tư thế gập người về ph&iacute;a trước. Ngo&agrave;i ra, c&aacute;c cơ quan kh&aacute;c như mắt cũng c&oacute; thể bị vi&ecirc;m theo.</p>

<p>C&aacute;c yếu tố nguy cơ của bệnh bao gồm:</p>

<ul>
	<li>Giới t&iacute;nh: Nam giới c&oacute; nguy cơ mắc bệnh vi&ecirc;m cột sống d&iacute;nh khớp cao hơn so với nữ giới.</li>
	<li>Tuổi t&aacute;c: C&aacute;c triệu chứng khởi ph&aacute;t thường xuất hiện ở cuối tuổi vị th&agrave;nh ni&ecirc;n hoặc đầu tuổi trưởng th&agrave;nh.</li>
	<li>Di truyền: Nhiều nghi&ecirc;n cứu cho thấy hầu hết c&aacute;c trường hợp vi&ecirc;m cột sống d&iacute;nh khớp đều mang gen HLA-B27. Tuy nhi&ecirc;n, kh&ocirc;ng phải tất cả c&aacute;c trường hợp mang gen n&agrave;y đều ph&aacute;t triển bệnh vi&ecirc;m cột sống d&iacute;nh khớp.</li>
</ul>

<p>Hiện chưa c&oacute; phương ph&aacute;p điều trị vi&ecirc;m khớp n&agrave;o c&oacute; thể chữa khỏi ho&agrave;n to&agrave;n bệnh vi&ecirc;m cột sống d&iacute;nh khớp, tuy nhi&ecirc;n, c&aacute;c phương ph&aacute;p hỗ trợ điều trị vi&ecirc;m khớp hiện nay c&oacute; thể giảm nhẹ c&aacute;c triệu chứng v&agrave; l&agrave;m chậm sự tiến triển của bệnh.</p>

<h3>2.6 Gout</h3>

<p>Gout l&agrave; một bệnh li&ecirc;n quan đến khớp xảy ra khi c&aacute;c tinh thể axit uric, hoặc urat monosodium, tạo th&agrave;nh trong c&aacute;c m&ocirc; v&agrave; chất lỏng của cơ thể. Nguy&ecirc;n nh&acirc;n của bệnh l&agrave; do cơ thể sản xuất qu&aacute; nhiều axit uric hoặc kh&ocirc;ng loại bỏ được lượng axit uric dư thừa.</p>

<p>Bệnh Gout g&acirc;y ra những cơn đau khủng khiếp ở c&aacute;c khớp, xung quanh khớp bị đỏ, n&oacute;ng v&agrave; sưng l&ecirc;n. &nbsp;</p>

<p>Những người sau đ&acirc;y c&oacute; nguy cơ cao mắc bệnh gout v&agrave; cần điều trị vi&ecirc;m khớp:</p>

<ul>
	<li><a href="https://www.vinmec.com/vie/bai-viet/nao-duoc-coi-la-thua-can-beo-phi-vi" target="_blank">Thừa c&acirc;n</a>&nbsp;hoặc b&eacute;o ph&igrave;.</li>
	<li>Tăng huyết &aacute;p.</li>
	<li>Thường xuy&ecirc;n sử dụng rượu v&agrave; bia.</li>
	<li>Sử dụng thuốc lợi tiểu.</li>
	<li>Ăn nhiều thịt đỏ v&agrave; hải sản.</li>
	<li>Chức năng thận suy giảm.</li>
</ul>

<h3>2.7 Lupus ban đỏ</h3>

<p>Lupus ban đỏ (SLE), l&agrave; một bệnh tự miễn. Hệ thống miễn dịch của người bị SLE kh&ocirc;ng hoạt động như b&igrave;nh thường m&agrave; tấn c&ocirc;ng c&aacute;c m&ocirc; khỏe mạnh trong cơ thể, dẫn đến vi&ecirc;m nhiễm v&agrave; tổn thương m&ocirc;. Bệnh n&agrave;y thường c&oacute; c&aacute;c giai đoạn b&ugrave;ng ph&aacute;t v&agrave; thuy&ecirc;n giảm sau đ&oacute;.</p>

<p>Lupus ban đỏ c&oacute; thể ph&aacute;t triển ở bất kỳ độ tuổi n&agrave;o, nhưng thường bắt đầu ở độ tuổi từ 15 đến 45. Số lượng phụ nữ mắc bệnh n&agrave;y thường cao hơn nam giới, với mỗi nam giới mắc bệnh lupus, c&oacute; từ 4 đến 12 phụ nữ cũng bị lupus.</p>

<p>Bệnh lupus c&oacute; thể ảnh hưởng đến nhiều bộ phận của cơ thể như khớp, da, n&atilde;o, phổi, thận, mạch m&aacute;u v&agrave; c&aacute;c m&ocirc; kh&aacute;c. C&aacute;c triệu chứng thường bao gồm mệt mỏi, đau, sưng khớp, ph&aacute;t ban tr&ecirc;n da v&agrave; sốt.</p>

<p>Nguy&ecirc;n nh&acirc;n g&acirc;y ra lupus vẫn chưa được kết luận ch&iacute;nh x&aacute;c, nhưng c&oacute; thể li&ecirc;n quan đến yếu tố di truyền, m&ocirc;i trường v&agrave; nội tiết tố.</p>

<h3>2.8 Vi&ecirc;m khớp vảy nến</h3>

<p>Vi&ecirc;m khớp vảy nến l&agrave; một vấn đề phổ biến m&agrave; thường xuất hiện ở bệnh nh&acirc;n mắc bệnh vảy nến (khoảng từ 6 đến 42% số người mắc bệnh vảy nến cũng mắc bệnh vi&ecirc;m khớp vảy nến) v&agrave; bệnh nh&acirc;n cần điều trị vi&ecirc;m khớp từ sớm.</p>

<p>Nguy&ecirc;n nh&acirc;n ch&iacute;nh x&aacute;c của bệnh vi&ecirc;m khớp vảy nến vẫn chưa được x&aacute;c định r&otilde;, nhưng c&oacute; khả năng li&ecirc;n quan đến những phản ứng bất thường của hệ thống miễn dịch, khi hệ thống n&agrave;y tấn c&ocirc;ng c&aacute;c tế b&agrave;o v&agrave; m&ocirc; khỏe mạnh. Sự phản ứng miễn dịch kh&ocirc;ng b&igrave;nh thường n&agrave;y dẫn đến vi&ecirc;m ở khớp v&agrave; sản xuất tế b&agrave;o da qu&aacute; mức.</p>

<p>C&aacute;c yếu tố tăng nguy cơ phải điều trị vi&ecirc;m khớp vảy nến bao gồm:</p>

<ul>
	<li>Mắc bệnh vảy nến m&atilde;n t&iacute;nh.</li>
	<li>Yếu tố di truyền.</li>
	<li>Tuổi t&aacute;c: Người ở độ tuổi từ 30 đến 50 c&oacute; nguy cơ mắc bệnh cao hơn.</li>
</ul>

<h3>2.9 Đau cơ xơ h&oacute;a</h3>

<p>Đau cơ xơ h&oacute;a l&agrave; một căn bệnh thường bắt đầu ở độ tuổi trung ni&ecirc;n, tuy nhi&ecirc;n, c&oacute; thể xuất hiện ở trẻ em. C&aacute;c triệu chứng phổ biến của bệnh bao gồm cảm gi&aacute;c đau lan rộng, rối loạn giấc ngủ, mệt mỏi, t&acirc;m trạng kh&ocirc;ng ổn định, suy giảm sự tập trung v&agrave; tr&iacute; nhớ.</p>

<p>Ngo&agrave;i ra, người bệnh c&oacute; thể gặp phải c&aacute;c triệu chứng như ngứa hoặc t&ecirc; ở b&agrave;n tay, b&agrave;n ch&acirc;n, đau ở h&agrave;m v&agrave; c&aacute;c vấn đề ti&ecirc;u h&oacute;a. C&aacute;c yếu tố dưới đ&acirc;y c&oacute; li&ecirc;n quan mật thiết đến sự xuất hiện của căn bệnh n&agrave;y:</p>

<ul>
	<li>Căng thẳng thường xuy&ecirc;n.</li>
	<li>Mắc phải chứng rối loạn căng thẳng sau chấn thương (PTSD).</li>
	<li>Chấn thương do c&aacute;c hoạt động lặp đi lặp lại.</li>
	<li>Mắc bệnh lupus, vi&ecirc;m khớp dạng thấp hoặc hội chứng mệt mỏi m&atilde;n t&iacute;nh.</li>
	<li>Yếu tố di truyền.</li>
	<li>Thừa c&acirc;n v&agrave; b&eacute;o ph&igrave;.</li>
	<li>Giới t&iacute;nh: Bệnh thường ph&aacute;t triển phổ biến hơn ở phụ nữ.</li>
</ul>

<p>Ngo&agrave;i ra, một số t&igrave;nh trạng vi&ecirc;m khớp kh&aacute;c c&oacute; thể bao gồm vi&ecirc;m đa khớp (t&igrave;nh trạng vi&ecirc;m ở nhiều khớp), vi&ecirc;m m&agrave;ng hoạt dịch, vi&ecirc;m khớp li&ecirc;n quan đến vi&ecirc;m ruột,...</p>

<h2>3. Nguy&ecirc;n nh&acirc;n g&acirc;y bệnh</h2>

<p>Mỗi loại bệnh vi&ecirc;m khớp bắt nguồn từ những nguy&ecirc;n nh&acirc;n kh&aacute;c nhau, nhưng c&oacute; thể ph&acirc;n chia th&agrave;nh hai nh&oacute;m nguy&ecirc;n nh&acirc;n ch&iacute;nh:</p>

<ul>
	<li>Nguy&ecirc;n nh&acirc;n tại khớp: Bao gồm vi&ecirc;m sụn, tho&aacute;i h&oacute;a, b&agrave;o m&ograve;n sụn khớp, chấn thương khớp, nhiễm khuẩn tại khớp&hellip;</li>
	<li>Nguy&ecirc;n nh&acirc;n ngo&agrave;i khớp: Thường g&acirc;y ra do c&aacute;c rối loạn chuyển h&oacute;a (như tăng acid uric trong bệnh g&uacute;t) hoặc bất thường trong hệ thống miễn dịch g&acirc;y tổn thương cho c&aacute;c th&agrave;nh phần trong khớp (như bệnh vi&ecirc;m khớp dạng thấp). Những t&igrave;nh trạng n&agrave;y ảnh hưởng đến hoạt động v&agrave; cấu tr&uacute;c của khớp, n&ecirc;n cần phải điều trị vi&ecirc;m khớp.</li>
</ul>

<h2>4. Triệu chứng bệnh</h2>

<p>Dấu hiệu của vi&ecirc;m khớp thay đổi t&ugrave;y thuộc v&agrave;o vị tr&iacute; v&agrave; loại vi&ecirc;m khớp, nhưng những triệu chứng cảnh b&aacute;o về vi&ecirc;m khớp bao gồm:</p>

<p>&nbsp;</p>

<ul>
	<li>Đau ở khớp, c&oacute; thể đau khi di chuyển hoặc ngay cả khi kh&ocirc;ng di chuyển.</li>
	<li>Hạn chế khả năng hoạt động của khớp, thường đi k&egrave;m với đau.</li>
	<li>C&aacute;c trường hợp vi&ecirc;m khớp cấp t&iacute;nh thường xuất hiện t&igrave;nh trạng sưng, cứng khớp.</li>
	<li>Vi&ecirc;m tại chỗ hoặc xung quanh khớp.</li>
	<li>Da xung quanh khớp bị đỏ.</li>
	<li>Tiếng động lạ khi di chuyển khớp, thường xảy ra v&agrave;o buổi s&aacute;ng.</li>
	<li>C&aacute;c triệu chứng ngo&agrave;i khớp c&oacute; thể bao gồm sốt, ph&aacute;t ban hoặc ngứa, kh&oacute; thở, giảm c&acirc;n... Tuy nhi&ecirc;n, những triệu chứng n&agrave;y cũng c&oacute; thể l&agrave; dấu hiệu của c&aacute;c bệnh kh&aacute;c.&nbsp;</li>
</ul>

<p><img alt="Điều trị viêm khớp tùy thuộc vào vị trí và loại viêm khớp. " src="https://www.vinmec.com/static/uploads/small_20200514_100810_424062_screenshot_15894508_max_1800x1800_png_f00f6bcc13.png" /></p>

<p>Điều trị vi&ecirc;m khớp t&ugrave;y thuộc v&agrave;o vị tr&iacute; v&agrave; loại vi&ecirc;m khớp.</p>

<h2>5. Đối tượng nguy cơ phải điều trị vi&ecirc;m khớp</h2>

<p>Yếu tố l&agrave;m tăng nguy cơ mắc bệnh v&agrave; cần phải điều trị vi&ecirc;m khớp, bao gồm:</p>

<ul>
	<li>Tuổi: Mặc d&ugrave; vi&ecirc;m khớp c&oacute; thể ảnh hưởng đến cả trẻ em, nhưng người cao tuổi thường c&oacute; tỷ lệ mắc bệnh cao hơn. Nguy&ecirc;n nh&acirc;n do ảnh hưởng của c&aacute;c rối loạn chuyển h&oacute;a v&agrave; c&aacute;c chấn thương đ&atilde; t&iacute;ch tụ trong thời gian d&agrave;i.</li>
	<li>Giới t&iacute;nh: Phụ nữ thường bị vi&ecirc;m khớp nhiều hơn nam giới.</li>
	<li>Nghề nghiệp: C&aacute;c c&ocirc;ng việc lao động nặng, l&agrave;m việc trong thời gian d&agrave;i ở c&ugrave;ng một tư thế, hoặc vận động kh&ocirc;ng đ&uacute;ng tư thế c&oacute; thể tăng nguy cơ mắc bệnh v&agrave; cần điều trị vi&ecirc;m khớp.</li>
	<li>Chấn thương: C&aacute;c chấn thương tại khớp c&oacute; thể g&acirc;y ra vi&ecirc;m khớp cấp t&iacute;nh ngay lập tức hoặc tăng nguy cơ vi&ecirc;m khớp trong tương lai.</li>
	<li>Thừa c&acirc;n: Thừa c&acirc;n tạo &aacute;p lực lớn l&ecirc;n c&aacute;c khớp, g&acirc;y ra c&aacute;c bệnh vi&ecirc;m khớp hoặc tăng tốc độ của qu&aacute; tr&igrave;nh vi&ecirc;m đang diễn ra tại khớp.</li>
	<li>C&aacute;c rối loạn trao đổi chất: C&aacute;c rối loạn n&agrave;y c&oacute; thể ảnh hưởng đến việc cung cấp dưỡng chất cho c&aacute;c th&agrave;nh phần của khớp v&agrave; g&acirc;y ra sự xuất hiện của c&aacute;c th&agrave;nh phần bất thường trong khớp.</li>
	<li>C&aacute;c bệnh hệ thống miễn dịch v&agrave; một số rối loạn di truyền cũng c&oacute; thể tăng nguy cơ mắc bệnh v&agrave; cần điều trị vi&ecirc;m khớp.</li>
</ul>

<h2>6. C&aacute;ch chẩn đo&aacute;n vi&ecirc;m khớp</h2>

<p>Mỗi loại bệnh vi&ecirc;m khớp đều c&oacute; ti&ecirc;u chuẩn chẩn đo&aacute;n ri&ecirc;ng về mặt l&acirc;m s&agrave;ng v&agrave; x&eacute;t nghiệm. Đối với việc chẩn đo&aacute;n vi&ecirc;m khớp, trong trường hợp c&oacute; triệu chứng đau tại khớp, c&aacute;c phương ph&aacute;p sau thường được &aacute;p dụng:</p>

<ul>
	<li>Kh&aacute;m bệnh: Đầu ti&ecirc;n l&agrave; tiến h&agrave;nh một cuộc kh&aacute;m bệnh kỹ lưỡng, bao gồm thăm hỏi về c&aacute;c triệu chứng cơ bản v&agrave; kh&aacute;m x&aacute;c định tầm vận động, sự biến dạng của khớp v&agrave; một số phương ph&aacute;p để x&aacute;c định c&oacute; dịch trong khớp hay kh&ocirc;ng.</li>
	<li>X&eacute;t nghiệm cơ bản: Bao gồm c&aacute;c x&eacute;t nghiệm m&aacute;u như tế b&agrave;o m&aacute;u ngoại vi, tốc độ trầm t&iacute;nh, protein phản ứng C (CRP), cũng như x&eacute;t nghiệm chức năng gan v&agrave; thận. Ngo&agrave;i ra, chụp&nbsp;<a href="https://www.vinmec.com/vie/bai-viet/chup-x-quang-la-gi-tat-ca-nhung-dieu-can-biet-vi" target="_blank">X-quang</a>&nbsp;tim phổi v&agrave; điện t&acirc;m đồ cũng được thực hiện để kiểm tra t&igrave;nh trạng của hệ tim mạch.</li>
	<li>Chụp X-quang khớp: Phương ph&aacute;p n&agrave;y gi&uacute;p ph&aacute;t hiện c&aacute;c biến đổi cấu tr&uacute;c của khớp.</li>
	<li>Chụp Xạ h&igrave;nh xương: L&agrave; phương ph&aacute;p hiện đại để ph&aacute;t hiện c&aacute;c thay đổi về h&igrave;nh dạng của xương khớp v&agrave; cũng c&oacute; thể ph&aacute;t hiện c&aacute;c rối loạn về chuyển h&oacute;a. Đặc biệt, n&oacute; c&oacute; khả năng ph&aacute;t hiện sớm c&aacute;c vấn đề như ung thư v&agrave; u xương khớp. Phương ph&aacute;p n&agrave;y đ&atilde; được &aacute;p dụng tại nhiều bệnh viện lớn, đặc biệt l&agrave; bệnh viện Vinmec với kết quả cao.</li>
	<li>X&eacute;t nghiệm miễn dịch kh&aacute;c: Trong trường hợp của vi&ecirc;m khớp dạng thấp, c&aacute;c x&eacute;t nghiệm như định lượng yếu tố dạng thấp (RH) v&agrave; anti CCP thường được thực hiện để đ&aacute;nh gi&aacute; sự tổn thương của khớp.&nbsp;</li>
</ul>

<p><img alt="Trật khớp cùng đón trái trên phim chụp X- quang
" src="https://www.vinmec.com/static/uploads/20200616_134024_560235_tratkhopcungdon_max_1800x1800_jpg_0cbe365711.jpg" /></p>

<p>Trật khớp c&ugrave;ng đ&oacute;n tr&aacute;i tr&ecirc;n phim chụp X- quang</p>

<h2>7. C&aacute;c biến chứng thường gặp</h2>

<p>Mỗi loại bệnh mang lại những biến chứng ri&ecirc;ng m&agrave; người bệnh cần ch&uacute; &yacute;:</p>

<ul>
	<li>Tho&aacute;i h&oacute;a khớp: G&acirc;y ra rối loạn giấc ngủ, nguy cơ về v&ocirc;i h&oacute;a sụn khớp, biến dạng khớp, v&agrave; gout. Nếu kh&ocirc;ng được điều trị vi&ecirc;m khớp, c&oacute; thể dẫn đến t&igrave;nh trạng liệt.</li>
	<li>Vi&ecirc;m khớp dạng thấp: C&oacute; thể ph&aacute; hủy c&aacute;c khớp, biến dạng ng&oacute;n tay v&agrave; cổ tay, cũng như g&acirc;y ra c&aacute;c biến chứng nghi&ecirc;m trọng như nốt thấp, hội chứng Sjogren, vi&ecirc;m m&agrave;ng ngo&agrave;i tim, vi&ecirc;m mạch m&aacute;u, vi&ecirc;m m&agrave;ng phổi, COPD, v&agrave; vi&ecirc;m xơ cứng.</li>
	<li>Lupus: C&oacute; thể g&acirc;y tổn thương cho da, tim, phổi, thận, m&aacute;u, v&agrave; n&atilde;o. C&aacute;c biến chứng của lupus c&oacute; thể g&acirc;y sảy thai, cao huyết &aacute;p trong thai kỳ v&agrave; sinh non.</li>
	<li>Gout: Nồng độ axit uric cao c&oacute; thể dẫn đến sỏi thận v&agrave; gout. Nếu chức năng thận k&eacute;m, c&oacute; nguy cơ mắc bệnh thận cấp t&iacute;nh do axit uric, l&agrave;m suy giảm chức năng thận.</li>
	<li>Vi&ecirc;m cột sống d&iacute;nh khớp: Khi c&aacute;c đốt sống hợp nhất, c&oacute; thể g&acirc;y ra cảm gi&aacute;c cứng v&agrave; kh&ocirc;ng linh hoạt. Cũng ảnh hưởng đến c&aacute;c khớp kh&aacute;c v&agrave; c&oacute; thể g&acirc;y ra vấn đề về mắt, tim, phổi, v&agrave; hệ ti&ecirc;u h&oacute;a.</li>
	<li>Vi&ecirc;m khớp nhiễm khuẩn: G&acirc;y trật khớp v&agrave; mất chức năng vận động. C&oacute; thể ảnh hưởng đến cột sống v&agrave; lan sang c&aacute;c bộ phận kh&aacute;c như gan, phổi, v&agrave; thận.</li>
	<li>Vi&ecirc;m khớp phản ứng: G&acirc;y ra biến chứng như h&oacute;a sừng, vi&ecirc;m kết mạc, vi&ecirc;m tiền liệt, v&agrave; tiểu mủ v&ocirc; khuẩn.</li>
	<li>Đau cơ xơ h&oacute;a: G&acirc;y cảm gi&aacute;c mệt mỏi, trầm cảm, v&agrave; mất ngủ. C&oacute; thể g&acirc;y ra c&aacute;c biến chứng như đau đầu, đau bụng dưới, v&agrave; chứng ngưng thở khi ngủ, cần điều trị vi&ecirc;m khớp để cải thiện chất lượng cuộc sống.</li>
</ul>

<h2>8. C&aacute;ch điều trị vi&ecirc;m khớp</h2>

<p>Hầu hết c&aacute;c bệnh vi&ecirc;m khớp đều được xem l&agrave; bệnh mạn t&iacute;nh, ngoại trừ vi&ecirc;m khớp do nhiễm khuẩn. Ch&iacute;nh v&igrave; thế, vi&ecirc;m khớp rất kh&oacute; để điều trị dứt điểm. Mục ti&ecirc;u ch&iacute;nh của&nbsp;<strong>điều trị vi&ecirc;m khớp</strong>&nbsp;l&agrave; giảm đau, gi&uacute;p khớp hoạt động trở lại hoạt động b&igrave;nh thường, ngăn ngừa tổn thương th&ecirc;m cho khớp. &nbsp;</p>

<p>Một số phương ph&aacute;p như chườm đ&aacute; v&agrave; sử dụng miếng d&aacute;n c&oacute; thể gi&uacute;p l&agrave;m dịu cơn đau hiệu quả. Một số bệnh nh&acirc;n kh&aacute;c c&oacute; thể sử dụng c&aacute;c thiết bị hỗ trợ di chuyển như gậy hoặc khung tập đi để giảm g&acirc;y &aacute;p lực l&ecirc;n c&aacute;c khớp đau.</p>

<p>B&ecirc;n cạnh việc giảm cơn đau, b&aacute;c sĩ cũng c&oacute; thể chỉ định một số phương ph&aacute;p kh&aacute;c để điều trị vi&ecirc;m khớp, bao gồm:</p>

<h3>8.1 Điều trị nội khoa: &nbsp;</h3>

<p>Phương ph&aacute;p&nbsp;<a href="https://www.vinmec.com/vie/bai-viet/thuoc-medlon-cong-dung-va-luu-y-khi-su-dung-vi" target="_blank">điều trị vi&ecirc;m khớp</a>&nbsp;n&agrave;y c&oacute; thể &aacute;p dụng đối với hầu hết trường hợp. B&aacute;c sĩ c&oacute; thể chỉ định bệnh nh&acirc;n chỉ điều trị bằng thuốc hoặc kết hợp với c&aacute;c phương ph&aacute;p điều trị kh&aacute;c.</p>

<p>Thuốc được sử dụng sẽ phụ thuộc v&agrave;o loại vi&ecirc;m khớp m&agrave; bệnh nh&acirc;n mắc phải, trong đ&oacute; c&oacute; thuốc giảm đau chống vi&ecirc;m, thuốc đặc hiệu cho từng loại bệnh v&agrave; nguy&ecirc;n nh&acirc;n. Bệnh nh&acirc;n cần tu&acirc;n theo chỉ định của b&aacute;c sĩ trong qu&aacute; tr&igrave;nh sử dụng thuốc:</p>

<ul>
	<li>Thuốc giảm đau: Một số loại thuốc giảm đau như hydrocodone (Vicodin) hoặc acetaminophen (Tylenol) c&oacute; t&aacute;c dụng kiểm so&aacute;t cơn đau, nhưng kh&ocirc;ng hỗ trợ giảm vi&ecirc;m.</li>
	<li>Thuốc chống vi&ecirc;m kh&ocirc;ng steroid (NSAID): Như ibuprofen (Advil) v&agrave; salicylat, gi&uacute;p điều trị vi&ecirc;m khớp.</li>
	<li>Menthol hoặc kem capsaicin: C&oacute; thể ngăn chặn truyền t&iacute;n hiệu đau từ c&aacute;c khớp đến n&atilde;o.</li>
	<li>Thuốc ức chế miễn dịch: Như prednisone hoặc cortisone c&oacute; thể gi&uacute;p giảm vi&ecirc;m.&nbsp;</li>
</ul>

<p><img alt="Bác sĩ có thể chỉ định bệnh nhân điều trị viêm khớp bằng thuốc. " src="https://www.vinmec.com/static/uploads/large_bac_si_co_the_chi_dinh_benh_nhan_dieu_tri_viem_khop_bang_thuoc_7bdd8b942b.jpg" /></p>

<p>B&aacute;c sĩ c&oacute; thể chỉ định bệnh nh&acirc;n điều trị vi&ecirc;m khớp bằng thuốc.</p>

<h3>8.2 Điều trị nội khoa</h3>

<p>B&aacute;c sĩ thường chỉ định bệnh nh&acirc;n thực hiện phẫu thuật trong c&aacute;c trường hợp sau:</p>

<ul>
	<li>Khớp kh&ocirc;ng hoạt động được.</li>
	<li>T&igrave;nh trạng đau k&eacute;o d&agrave;i do kh&ocirc;ng đ&aacute;p ứng điều trị nội khoa.</li>
	<li>Ảnh hưởng lớn đối với cuộc sống hằng ng&agrave;y hoặc g&acirc;y mất thẩm mỹ của bệnh nh&acirc;n</li>
</ul>

<p>C&aacute;c phương ph&aacute;p phẫu thuật được thực hiện để điều trị vi&ecirc;m khớp bao gồm:</p>

<ul>
	<li>Phẫu thuật tạo h&igrave;nh, thay thế khớp.</li>
	<li>Phẫu thuật l&agrave;m cứng khớp: Kh&oacute;a c&aacute;c đầu xương lại với nhau cho đến khi được chữa khỏi ho&agrave;n to&agrave;n.</li>
	<li>Tạo h&igrave;nh xương: Phương ph&aacute;p phẫu thuật t&aacute;i tạo xương được thực hiện để đảm bảo khả năng thực hiện chức năng của khớp.</li>
</ul>

<h3>8.3 Điều trị tại nh&agrave;</h3>

<p>B&ecirc;n cạnh c&aacute;c phương ph&aacute;p điều trị, chế độ sinh hoạt đ&oacute;ng vai tr&ograve; quan trọng trong việc phục hồi sức khoẻ của bệnh nh&acirc;n vi&ecirc;m khớp. Bệnh nh&acirc;n cần quan t&acirc;m đến chế độ tập luyện thể dục v&agrave; ăn uống hằng ng&agrave;y:</p>

<ul>
	<li>Những b&agrave;i tập thể dục nhẹ nh&agrave;ng v&agrave; thường gi&uacute;p khớp linh hoạt v&agrave; hoạt động dẻo dai hơn. Bơi lội l&agrave; m&ocirc;n thể thao ph&ugrave; hợp đối với người bệnh do giảm &aacute;p lực l&ecirc;n c&aacute;c khớp. Tuy nhi&ecirc;n, người bệnh chỉ n&ecirc;n tập luyện vừa sức.</li>
	<li>Người bệnh thừa c&acirc;n n&ecirc;n ch&uacute; &yacute; giảm h&agrave;m lượng tinh bột trong chế độ ăn. B&ecirc;n cạnh đ&oacute;, việc tăng cường c&aacute;c loại thực phẩm chứa nhiều chất oxy ho&aacute; sẽ c&oacute; t&aacute;c dụng giảm vi&ecirc;m. Duy tr&igrave; chế độ ăn đủ chất dinh dưỡng sẽ hạn chế vi&ecirc;m khớp tiến triển nặng hơn.</li>
</ul>

<h2>9. C&aacute;ch ph&ograve;ng ngừa</h2>

<p>Vi&ecirc;m khớp l&agrave; một căn bệnh rất kh&oacute; ph&ograve;ng ngừa, tuy nhi&ecirc;n ch&uacute;ng ta cũng c&oacute; thể giảm nguy cơ mắc bệnh v&agrave; kiểm so&aacute;t bệnh tốt hơn nhờ v&agrave;o c&aacute;c biện ph&aacute;p sau: &nbsp;</p>

<ul>
	<li>Tập thể dục: Lựa chọn c&aacute;c m&ocirc;n thể thao ph&ugrave; hợp dựa tr&ecirc;n độ tuổi, t&igrave;nh trạng sức khỏe v&agrave; nhiều điều kiện kh&aacute;c.</li>
	<li>Thực hiện chế độ ăn l&agrave;nh mạnh, tr&aacute;nh thừa c&acirc;n, b&eacute;o ph&igrave;.</li>
	<li>Đảm bảo thực hiện an to&agrave;n lao động, tr&aacute;nh c&aacute;c chấn thương g&acirc;y ảnh hưởng đến khớp.</li>
	<li>L&agrave;m việc đ&uacute;ng tư thế.</li>
	<li>Thăm kh&aacute;m, kiểm tra sức khỏe định kỳ để kịp thời ph&aacute;t hiện v&agrave; điều trị c&aacute;c rối loạn chuyển ho&aacute; trong cơ thể.&nbsp;</li>
</ul>
', '2025-07-14 15:00:25', '2025-07-19 14:09:13', 4);
INSERT INTO swp_db.news (id, title, image_preview, short_description, description, created_at, updated_at, created_by)
VALUES ( 4, 'Các bệnh tim mạch thường gặp ở trẻ em'
       , 'https://www.vinmec.com/static/uploads/20210404_151245_052891_Benh_tim_bam_sinh_max_1800x1800_jpg_4f3916463d.jpg'
       , 'Các bệnh tim mạch không chỉ phổ biến ở người lớn mà còn có tỷ lệ xảy ra khá cao ở trẻ em. Các bệnh tim mạch thường gặp ở trẻ em thường có diễn biến nghiêm trọng nếu không được phát hiện, điều trị tích cực. Vậy đó là những căn bệnh gì?'
       , '<h2>. Bệnh tim bẩm sinh ở trẻ em</h2>

<p>&nbsp;</p>

<p>Khi điểm qua&nbsp;<strong>1 số bệnh về tim mạch</strong>&nbsp;ở trẻ em,&nbsp;<a href="https://www.vinmec.com/vie/benh/tim-bam-sinh-3108"><strong>bệnh tim bẩm sinh</strong></a>&nbsp;l&agrave; đ&aacute;ng lưu &yacute; nhất. Đ&acirc;y l&agrave; những dị tật tim được h&igrave;nh th&agrave;nh ngay từ trong b&agrave;o thai, do những bất thường trong qu&aacute; tr&igrave;nh ph&aacute;t triển của ph&ocirc;i thai.</p>

<p>C&aacute;c dạng bệnh tim bẩm sinh phổ biến ở trẻ em hầu hết l&agrave; bệnh tim thực thể với tỷ lệ mắc bệnh l&agrave; 8/1.000 trẻ sơ sinh. Nguy&ecirc;n nh&acirc;n g&acirc;y bệnh tim bẩm sinh ở trẻ em chủ yếu l&agrave; do bất thường cấu tr&uacute;c gen, người mẹ trong qu&aacute; tr&igrave;nh mang thai bị nhiễm si&ecirc;u vi (Rubella, sởi, quai bị, c&uacute;m,...), nhiễm độc chất (thuốc l&aacute;, rượu, tia xạ, h&oacute;a chất, thuốc an thần,...), mắc bệnh l&yacute; m&atilde;n t&iacute;nh như tiểu đường hay lupus ban đỏ,...</p>

<p>C&oacute; 3 loại tật tim bẩm sinh ch&iacute;nh ở trẻ em l&agrave;:</p>

<ul>
	<li>Hẹp c&aacute;c th&agrave;nh phần trong tim: Hẹp van tim, hẹp c&aacute;c mạch m&aacute;u ngo&agrave;i tim,... T&igrave;nh trạng n&agrave;y dẫn tới tắc nghẽn luồng m&aacute;u chảy, ứ m&aacute;u trong c&aacute;c buồng tim, g&acirc;y d&agrave;y gi&atilde;n c&aacute;c buồng tim như&nbsp;<a href="https://www.vinmec.com/vie/bai-viet/hep-van-dong-mach-chu-nguyen-nhan-trieu-chung-bien-chung-vi"><strong>hẹp van động mạch chủ</strong></a>, hẹp van động mạch phổi, hẹp van 2 l&aacute;;</li>
	<li>C&oacute; c&aacute;c lỗ thủng ở v&aacute;ch ngăn giữa c&aacute;c buồng tim (th&ocirc;ng li&ecirc;n thất, th&ocirc;ng li&ecirc;n nhĩ). Những lỗ thủng n&agrave;y cho ph&eacute;p m&aacute;u chảy từ buồng tim b&ecirc;n n&agrave;y sang buồng tim b&ecirc;n kia (c&ograve;n gọi l&agrave; luồng th&ocirc;ng). Khi &aacute;p lực ở buồng tim tr&aacute;i cao hơn, chiều luồng th&ocirc;ng sẽ đi từ tim tr&aacute;i qua tim phải, dẫn tới tăng lượng m&aacute;u l&ecirc;n phổi. B&ecirc;n cạnh đ&oacute;, luồng th&ocirc;ng c&oacute; thể kh&ocirc;ng chạy qua c&aacute;c lỗ thủng m&agrave; chạy qua ống động mạch tồn tại sau khi sinh. Ống động mạch n&agrave;y nối giữa động mạch chủ với động mạch phổi. Khi c&oacute; luồng th&ocirc;ng từ động mạch chủ sang động mạch phổi th&igrave; sẽ l&agrave;m tăng lưu lượng m&aacute;u l&ecirc;n phổi;</li>
	<li>C&aacute;c mạch m&aacute;u ch&iacute;nh xuất ph&aacute;t từ tim tại những vị tr&iacute; bất thường như&nbsp;<a href="https://www.vinmec.com/vie/bai-viet/chuyen-vi-dai-dong-mach-di-tat-tim-bam-sinh-nguy-hiem-vi"><strong>dị tật ho&aacute;n vị đại động mạch</strong></a>. B&igrave;nh thường, động mạch chủ xuất ph&aacute;t từ t&acirc;m thất tr&aacute;i mang m&aacute;u đỏ v&agrave; gi&agrave;u oxy đi nu&ocirc;i cơ thể. Động mạch phổi xuất ph&aacute;t từ t&acirc;m thất phải, mang m&aacute;u đen đi nu&ocirc;i phổi để trao đổi oxy. Với trẻ mắc tật ho&aacute;n vị đại động mạch, động mạch chủ v&agrave; phổi ho&aacute;n đổi vị tr&iacute; xuất ph&aacute;t cho nhau. Như vậy, m&aacute;u đen từ tĩnh mạch về tim phải được bơm l&ecirc;n động mạch chủ đi nu&ocirc;i cơ thể, khiến trẻ bị thiếu oxy, c&oacute; biểu hiện to&agrave;n th&acirc;n t&iacute;m t&aacute;i. Nếu kh&ocirc;ng được phẫu thuật sớm th&igrave; trẻ sẽ tử vong;</li>
	<li>Hội chứng suy tim tr&aacute;i bẩm sinh: Phần b&ecirc;n tr&aacute;i tim kh&ocirc;ng thể ph&aacute;t triển ho&agrave;n chỉnh.</li>
</ul>

<p>Trong&nbsp;<strong>c&aacute;c bệnh tim mạch thường gặp ở trẻ em</strong>, bệnh tim bẩm sinh rất nguy hiểm. Nếu kh&ocirc;ng điều trị, bệnh c&oacute; thể dẫn tới tim to, suy tim, t&iacute;m t&aacute;i nặng do thiếu oxy,... B&ecirc;n cạnh đ&oacute;, trẻ thường xuy&ecirc;n bị&nbsp;<a href="https://www.vinmec.com/vie/bai-viet/dieu-tri-nhiem-trung-mang-phoi-o-tre-em-vi"><strong>nhiễm tr&ugrave;ng phổi</strong></a>, chậm lớn, chậm ph&aacute;t triển t&acirc;m thần v&agrave; vận động. Thậm ch&iacute;, nếu bệnh nặng th&igrave; trẻ c&oacute; thể bị tử vong.</p>

<p>C&aacute;c b&aacute;c sĩ khuyến nghị c&oacute; thể ph&aacute;t hiện sớm c&aacute;c trường hợp trẻ mắc bệnh tim bẩm sinh th&ocirc;ng qua si&ecirc;u &acirc;m tim b&agrave;o thai khi thai được 16 tuần tuổi. C&aacute;c b&agrave; bầu n&ecirc;n đi kh&aacute;m thai định kỳ, nếu b&aacute;c sĩ thấy nghi ngờ sẽ kiểm tra si&ecirc;u &acirc;m tim b&agrave;o thai.</p>

<p>Hầu hết c&aacute;c bệnh tim bẩm sinh ở trẻ em đều c&oacute; thể điều trị được bằng phẫu thuật hoặc bằng phương ph&aacute;p th&ocirc;ng tim can thiệp. Để ph&ograve;ng ngừa bệnh tim bẩm sinh ở trẻ em, phụ nữ trước khi mang thai n&ecirc;n chủng ngừa sởi, quai bị, Rubella, c&uacute;m, điều trị ổn định c&aacute;c bệnh m&atilde;n t&iacute;nh trước khi mang thai. Đồng thời, phụ nữ n&ecirc;n tr&aacute;nh h&uacute;t thuốc, uống rượu, tiếp x&uacute;c với c&aacute;c chất độc hại. Đặc biệt, mẹ bầu n&ecirc;n cẩn thận khi sử dụng thuốc trong thời kỳ mang thai, chỉ d&ugrave;ng thuốc khi được b&aacute;c sĩ sản khoa cho ph&eacute;p.</p>

<h2>2. Bệnh tim mạch thường gặp ở trẻ em: Loạn nhịp tim</h2>

<p>&nbsp;</p>

<p><a href="https://www.vinmec.com/vie/bai-viet/dieu-tri-roi-loan-nhip-tim-vi"><strong>Rối loạn nhịp tim</strong></a>&nbsp;l&agrave; c&aacute;ch gọi chung cho một số t&igrave;nh trạng hoạt động điện của tim, c&oacute; rối loạn bất thường như nhanh, chậm hơn b&igrave;nh thường, l&agrave;m giảm hiệu quả bơm m&aacute;u của tim.</p>

<p>C&aacute;c loại rối loạn nhịp tim gồm: Tim đập nhanh, tim đập chậm, hội chứng Q-T d&agrave;i, hội chứng Wolff-Parkinson-White. C&aacute;c triệu chứng của bệnh bao gồm: Cơ thể yếu, mệt mỏi, ch&oacute;ng mặt, hoa mắt, ăn uống kh&oacute; khăn,...</p>

<p>Việc điều trị bệnh rối loạn nhịp tim ở trẻ em chủ yếu phụ thuộc v&agrave;o dạng bệnh m&agrave; trẻ mắc phải v&agrave; mức độ ảnh hưởng của n&oacute; đến sức khỏe của trẻ.</p>

<h2>3. Hội chứng Eisenmenger ở trẻ em</h2>

<p>&nbsp;</p>

<p>Mặc d&ugrave; kh&ocirc;ng phải l&agrave; một bệnh l&yacute; về tim mạch nhưng Eisenmenger thường dẫn đến một số hậu quả tr&ecirc;n tim mạch. Hội chứng n&agrave;y l&agrave; sự kết hợp của 3 triệu chứng sau:</p>

<p>&nbsp;</p>

<ul>
	<li>Chứng xanh t&iacute;m, da xanh t&aacute;i hoặc da x&aacute;m do giảm oxy trong m&aacute;u;</li>
	<li>Tăng huyết &aacute;p động mạch phổi;</li>
	<li>Đa hồng cầu nguy&ecirc;n ph&aacute;t.</li>
</ul>

<p><a href="https://www.vinmec.com/vie/benh/hoi-chung-eisenmenger-4454"><strong>Hội chứng Eisenmenger</strong></a>&nbsp;chủ yếu ảnh hưởng tới trẻ vị th&agrave;nh ni&ecirc;n v&agrave; người trưởng th&agrave;nh đ&atilde; mắc bệnh tim bẩm sinh n&agrave;o đ&oacute;. Tuy nhi&ecirc;n, kể cả trẻ sơ sinh cũng c&oacute; thể bị tăng huyết &aacute;p động mạch phổi. Về căn bản, hội chứng n&agrave;y l&agrave; t&igrave;nh trạng m&aacute;u kh&ocirc;ng được chảy đ&uacute;ng hướng từ b&ecirc;n tr&aacute;i tim sang b&ecirc;n phải tim. Nếu kh&ocirc;ng được điều trị, hội chứng Eisenmenger c&oacute; thể l&agrave;m h&igrave;nh th&agrave;nh c&aacute;c cục m&aacute;u đ&ocirc;ng, g&acirc;y đột quỵ v&agrave; suy thận.</p>

<p>Phương ph&aacute;p điều trị hội chứng Eisenmenger phụ thuộc v&agrave;o c&aacute;c triệu chứng của bệnh. B&aacute;c sĩ thường chỉ định bệnh nh&acirc;n sử dụng c&aacute;c loại thuốc để l&agrave;m giảm huyết &aacute;p động mạch phổi, kết hợp tr&iacute;ch m&aacute;u từ tĩnh mạch để l&agrave;m giảm t&igrave;nh trạng qu&aacute; thừa hồng cầu lưu th&ocirc;ng.</p>

<h2>4. C&aacute;c bệnh tim mạch thường gặp ở trẻ em: Xơ vữa động mạch</h2>

<p>&nbsp;</p>

<p><a href="https://www.vinmec.com/vie/bai-viet/xo-cung-dong-mach-hay-xo-vua-dong-mach-vi"><strong>Xơ vữa động mạch</strong></a>&nbsp;l&agrave; t&igrave;nh trạng h&igrave;nh th&agrave;nh c&aacute;c mảng chất b&eacute;o v&agrave; cholesterol trong l&ograve;ng động mạch. C&aacute;c mảng xơ vữa c&agrave;ng nhiều th&igrave; l&ograve;ng mạch c&agrave;ng cứng v&agrave; hẹp lại, l&agrave;m tăng nguy cơ h&igrave;nh th&agrave;nh c&aacute;c cục m&aacute;u đ&ocirc;ng v&agrave; dẫn tới c&aacute;c cơn đau tim. Đ&acirc;y l&agrave; căn bệnh tiến triển &acirc;m thầm, l&acirc;u d&agrave;i n&ecirc;n &iacute;t gặp ở trẻ nhỏ v&agrave; trẻ vị th&agrave;nh ni&ecirc;n.</p>

<p>Tuy nhi&ecirc;n, c&aacute;c yếu tố như b&eacute;o ph&igrave;, tiểu đường, huyết &aacute;p cao,... c&oacute; thể l&agrave;m gia tăng nguy cơ trẻ em mắc chứng xơ vữa động mạch. Do đ&oacute;, b&aacute;c sĩ khuyến c&aacute;o n&ecirc;n kiểm tra nồng độ cholesterol v&agrave; huyết &aacute;p cho những trẻ em bị thừa c&acirc;n, b&eacute;o ph&igrave; hoặc c&oacute; tiền sử gia đ&igrave;nh mắc c&aacute;c bệnh tim mạch, tiểu đường. Phương ph&aacute;p điều trị bệnh xơ vữa động mạch ở trẻ em bao gồm: Thay đổi lối sống như tăng cường vận động v&agrave; điều chỉnh chế độ dinh dưỡng.</p>

<h2>5. Bệnh tim mạch thường gặp ở trẻ em: Kawasaki</h2>

<p>&nbsp;</p>

<p>Đ&acirc;y l&agrave; căn bệnh đặc trưng bởi t&igrave;nh trạng vi&ecirc;m c&aacute;c mạch m&aacute;u ở tay, ch&acirc;n, miệng, m&ocirc;i v&agrave; họng. C&aacute;c triệu chứng của bệnh bao gồm sốt, sung huyết kết mạc mắt, m&ocirc;i kh&ocirc; nẻ chảy m&aacute;u, lưỡi đỏ, hồng ban tr&ecirc;n da, ni&ecirc;m mạc hầu họng đỏ rực, đỏ l&ograve;ng b&agrave;n tay v&agrave; b&agrave;n ch&acirc;n, bong da đầu ng&oacute;n tay v&agrave; ng&oacute;n ch&acirc;n, sưng hạch bạch huyết. Hiện nay, nguy&ecirc;n nh&acirc;n g&acirc;y bệnh n&agrave;y vẫn chưa được l&agrave;m s&aacute;ng tỏ.</p>

<p>Theo Hiệp hội tim mạch Hoa Kỳ (AHA),&nbsp;<a href="https://www.vinmec.com/vie/bai-viet/su-hinh-thanh-cua-benh-kawasaki-o-tre-vi"><strong>bệnh Kawasaki</strong></a>&nbsp;l&agrave; nguy&ecirc;n nh&acirc;n ch&iacute;nh g&acirc;y ra c&aacute;c bệnh tim mạch ở trẻ em (tỷ lệ l&agrave; 1/5 trẻ mắc bệnh tim). Bệnh Kawasaki c&oacute; thể dẫn tới biến chứng vi&ecirc;m, tắc động mạch v&agrave;nh, gi&atilde;n ph&igrave;nh động mạch v&agrave;nh v&agrave; g&acirc;y suy tim.</p>

<p>Việc điều trị bệnh Kawasaki phụ thuộc v&agrave;o mức độ nặng của bệnh, thường l&agrave; sử dụng gamma globulin IV v&agrave; aspirin. B&ecirc;n cạnh đ&oacute;, corticosteroid đ&ocirc;i khi được sử dụng để l&agrave;m giảm c&aacute;c biến chứng của bệnh. Đồng thời, trẻ mắc bệnh Kawasaki thường phải kiểm tra tim mạch nhiều lần trong cả đời.</p>

<h2>6. C&aacute;c bệnh tim mạch thường gặp ở trẻ em: Bệnh thấp tim</h2>

<p>&nbsp;</p>

<p>Nếu kh&ocirc;ng được điều trị triệt để, li&ecirc;n cầu khuẩn g&acirc;y vi&ecirc;m họng v&agrave; sốt scarlet c&oacute; thể dẫn tới bệnh thấp tim ở trẻ em. Đ&acirc;y l&agrave; căn bệnh nguy hiểm, c&oacute; thể g&acirc;y tổn thương vĩnh viễn cơ tim v&agrave; van tim. Nếu kh&ocirc;ng ph&aacute;t hiện v&agrave; điều trị kịp thời, trẻ c&oacute; thể bị suy tim cấp, g&acirc;y nguy hiểm tới t&iacute;nh mạng v&agrave; để lại c&aacute;c di chứng hở hẹp van tim dẫn tới suy tim m&atilde;n t&iacute;nh.</p>

<p><a href="https://www.vinmec.com/vie/bai-viet/tieu-chuan-chan-doan-benh-thap-tim-vi"><strong>Thấp tim</strong></a>&nbsp;thường gặp ở trẻ em từ 5 - 15 tuổi. Tuy nhi&ecirc;n, c&aacute;c triệu chứng của bệnh thường chỉ biểu hiện sau từ 5 - 20 năm. D&ugrave; nguy hiểm nhưng căn bệnh n&agrave;y ho&agrave;n to&agrave;n c&oacute; thể ph&ograve;ng tr&aacute;nh được bằng c&aacute;ch điều trị dứt điểm bệnh vi&ecirc;m họng do li&ecirc;n cầu khuẩn bằng thuốc kh&aacute;ng sinh.</p>

<h2>7. Vi&ecirc;m m&agrave;ng ngo&agrave;i tim</h2>

<p>&nbsp;</p>

<p>Vi&ecirc;m m&agrave;ng ngo&agrave;i tim l&agrave; bệnh l&yacute; xuất hiện khi lớp m&agrave;ng mỏng bao quanh tim bị vi&ecirc;m hay nhiễm khuẩn. Lớp dịch dư thừa t&iacute;ch tụ giữa 2 lớp quanh tim khiến tim kh&ocirc;ng thể thực hiện được chức năng bơm m&aacute;u.</p>

<p><a href="https://www.vinmec.com/vie/bai-viet/nguyen-nhan-gay-viem-mang-ngoai-tim-vi"><strong>Vi&ecirc;m m&agrave;ng ngo&agrave;i tim</strong></a>&nbsp;c&oacute; thể xuất hiện sau khi phẫu thuật tim do bệnh tim bẩm sinh hoặc do nhiễm khuẩn, chấn thương v&ugrave;ng ngực hoặc do rối loạn m&ocirc; li&ecirc;n kết ở bệnh Lupus ban đỏ. Việc điều trị căn bệnh n&agrave;y t&ugrave;y thuộc mức độ nặng của bệnh, độ tuổi, t&igrave;nh trạng sức khỏe của b&eacute;.</p>

<h2>8. Bệnh tim do virus ở trẻ em</h2>

<p>&nbsp;</p>

<p>Virus cũng l&agrave; t&aacute;c nh&acirc;n g&acirc;y bệnh tim mạch. Nhiễm virus c&oacute; thể dẫn tới vi&ecirc;m cơ tim, g&acirc;y ảnh hưởng đến khả năng bơm m&aacute;u của tim. C&aacute;c bệnh tim mạch do virus thường hiếm gặp, &iacute;t c&oacute; triệu chứng. Nếu c&oacute;, c&aacute;c triệu chứng thường kh&aacute; giống với bệnh c&uacute;m như kh&oacute; thở, mệt mỏi, tức ngực. Lựa chọn điều trị bệnh tim do virus ở trẻ em bao gồm d&ugrave;ng thuốc v&agrave; c&aacute;c liệu ph&aacute;p l&agrave;m giảm triệu chứng của vi&ecirc;m cơ tim.</p>

<p><strong>C&aacute;c bệnh tim mạch thường gặp ở trẻ em</strong>&nbsp;c&oacute; thể dự ph&ograve;ng được hoặc kh&ocirc;ng t&ugrave;y từng bệnh l&yacute; cụ thể. Do vậy, cha mẹ n&ecirc;n quan t&acirc;m tới sức khỏe của trẻ để ph&ograve;ng ngừa, ph&aacute;t hiện kịp thời c&aacute;c bệnh l&yacute; tim mạch để điều trị t&iacute;ch cực, đảm bảo tương lai cho b&eacute;.</p>
', '2025-07-14 16:00:25', '2025-07-19 14:09:13', 4);
INSERT INTO swp_db.news (id, title, image_preview, short_description, description, created_at, updated_at, created_by)
VALUES ( 5, 'Tiêm phòng uốn ván khi mang thai 20 tuần có sao không?'
       , 'https://www.vinmec.com/static/uploads/small_20191028_101250_994957_tiem_phong_cho_ba_b_max_1800x1800_png_1fc1a868d5.png'
       , 'Được giải đáp bởi Bác sĩ Nguyễn Vân Anh - Khoa Nhi - Sơ sinh, Bệnh viện Đa khoa ABC123', '<p><strong>Hỏi</strong></p>

<p><em>Ch&agrave;o b&aacute;c sĩ,</em></p>

<p><em>Th&aacute;ng 12 năm ngo&aacute;i, em bị ng&atilde; xe v&agrave; đ&atilde; ti&ecirc;m một mũi uốn v&aacute;n. Đến nay, em đang c&oacute; thai ở tuần thứ 20. Vậy b&aacute;c sĩ cho em hỏi&nbsp;</em><strong><em>ti&ecirc;m ph&ograve;ng uốn v&aacute;n khi mang thai 20 tuần c&oacute; sao kh&ocirc;ng?</em></strong><em>&nbsp;Em cần ti&ecirc;m th&ecirc;m 1 mũi uốn v&aacute;n nữa th&ocirc;i đ&uacute;ng kh&ocirc;ng? Em cảm ơn.</em></p>

<p><strong>Kh&aacute;ch h&agrave;ng ẩn danh</strong></p>

<p><strong>Trả lời</strong></p>

<p>Được giải đ&aacute;p bởi&nbsp;<strong>B&aacute;c sĩ Nguyễn V&acirc;n Anh&nbsp;</strong>- Khoa Nhi - Sơ sinh, Bệnh viện Đa khoa ABC123</p>

<p>Ch&agrave;o bạn,</p>

<p>Với c&acirc;u hỏi &ldquo;<strong>Ti&ecirc;m ph&ograve;ng uốn v&aacute;n khi mang thai 20 tuần c&oacute; sao kh&ocirc;ng?</strong>&rdquo;, b&aacute;c sĩ xin giải đ&aacute;p như sau:</p>

<p>&nbsp;</p>

<p>Trong thai kỳ phụ nữ trước sinh em b&eacute;, người mẹ cần ti&ecirc;m đủ 2 mũi uốn v&aacute;n để ph&ograve;ng ngừa uốn v&aacute;n cho trẻ sơ sinh. Trường hợp của bạn đ&atilde; ti&ecirc;m 1 mũi uốn v&aacute;n năm ngo&aacute;i th&igrave; khi mang thai bạn chỉ cần ti&ecirc;m th&ecirc;m 1 mũi uốn v&aacute;n nữa l&agrave; đủ.</p>

<p>Tuy nhi&ecirc;n, b&aacute;c sĩ khuyến c&aacute;o bạn n&ecirc;n hỏi th&ecirc;m b&aacute;c sĩ để được tư vấn ti&ecirc;m vacxin 3 trong 1 Bạch hầu - Uốn v&aacute;n - Ho g&agrave; từ tuần 27 - 33 tuần tuổi thai để mẹ c&oacute; kh&aacute;ng thể ph&ograve;ng ngừa lu&ocirc;n bệnh Ho g&agrave; cho trẻ sơ sinh trong thời gian b&eacute; chưa đủ th&aacute;ng tuổi để ti&ecirc;m ngừa.</p>

<p>Nếu bạn c&ograve;n thắc mắc về&nbsp;<strong>ti&ecirc;m ph&ograve;ng uốn v&aacute;n khi mang thai 20 tuần</strong>, bạn c&oacute; thể đến bệnh viện thuộc&nbsp;<a href="https://www.vinmec.com/vie/co-so-y-te/"><strong>Hệ thống Y tế G3</strong></a>&nbsp;để kiểm tra v&agrave; tư vấn th&ecirc;m. Cảm ơn bạn đ&atilde; tin tưởng v&agrave; gửi c&acirc;u hỏi đến G3. Ch&uacute;c bạn c&oacute; thật nhiều sức khỏe.</p>

<p>Tr&acirc;n trọng!</p>
', '2025-07-14 17:00:25', '2025-07-19 14:09:13', 4);
INSERT INTO swp_db.news (id, title, image_preview, short_description, description, created_at, updated_at, created_by)
VALUES ( 6, 'Gan: Cơ quan quý giá của cơ thể mà bạn cần biết'
       , 'https://cdn.youmed.vn/tin-tuc/wp-content/uploads/2020/07/Gi%E1%BA%A3i-ph%E1%BA%ABu-gan.jpg'
       , 'Gan là một cơ quan chỉ được tìm thấy ở động vật có xương sống, giúp giải độc các chất chuyển hóa khác nhau, tổng hợp protein và tạo ra các chất sinh hóa cần thiết cho quá trình tiêu hóa và tăng trưởng của cơ thể. Ở người, nó nằm ở góc phần tư phía trên bên phải của bụng, bên dưới cơ hoành. Các vai trò khác của gan trong quá trình trao đổi chất bao gồm điều hòa dự trữ glycogen, phân hủy tế bào hồng cầu và sản xuất các hormone. Nó nặng khoảng 1,2-1,4 kg, có màu nâu đỏ và cảm giác đàn hồi khi chạm vào. Thông thường bạn không thể cảm nhận thấy gan, bởi vì nó được bảo vệ bởi khung xương sườn.'
       , '<h2>Giải phẫu</h2>

<p>Gan c&oacute; hai phần lớn, được gọi l&agrave; th&ugrave;y phải v&agrave; th&ugrave;y tr&aacute;i. T&uacute;i mật nằm dưới gan, c&ugrave;ng với c&aacute;c bộ phận của tuyến tụy v&agrave; ruột. Gan v&agrave; c&aacute;c cơ quan n&agrave;y phối hợp với nhau để ti&ecirc;u h&oacute;a, hấp thụ thức ăn.</p>

<p>N&oacute; l&agrave; một cơ quan ti&ecirc;u h&oacute;a phụ gi&uacute;p tạo ra mật, một chất lỏng chứa cholesterol v&agrave; axit mật, gi&uacute;p ph&acirc;n hủy chất b&eacute;o. T&uacute;i mật, một t&uacute;i nhỏ nằm ngay dưới, lưu trữ mật do gan sản xuất, sau đ&oacute; được chuyển đến ruột non để ti&ecirc;u h&oacute;a ho&agrave;n to&agrave;n.&nbsp; C&aacute;c tế b&agrave;o gan, điều chỉnh nhiều loại phản ứng sinh h&oacute;a, bao gồm tổng hợp v&agrave; ph&aacute; vỡ c&aacute;c ph&acirc;n tử lớn v&agrave; phức tạp, cần thiết cho c&aacute;c chức năng quan trọng của cơ thể.</p>

<p>Gan kết nối với hai mạch m&aacute;u lớn: động mạch gan v&agrave; tĩnh mạch cửa. Động mạch gan mang m&aacute;u gi&agrave;u oxy từ động mạch chủ đến gan. Trong khi tĩnh mạch cửa mang m&aacute;u gi&agrave;u chất dinh dưỡng từ to&agrave;n bộ đường ti&ecirc;u h&oacute;a v&agrave; cả từ l&aacute;ch v&agrave; tuyến tụy. Những mạch m&aacute;u n&agrave;y ph&acirc;n chia th&agrave;nh c&aacute;c mao mạch nhỏ được gọi l&agrave; xoang gan, sau đ&oacute; dẫn đến th&ugrave;y gan. Th&ugrave;y l&agrave; đơn vị chức năng của gan. Mỗi tiểu th&ugrave;y được tạo th&agrave;nh từ h&agrave;ng triệu tế b&agrave;o gan, l&agrave; những tế b&agrave;o trao đổi chất cơ bản.</p>

<p><img alt="Giải phẫu gan" src="https://cdn.youmed.vn/tin-tuc/wp-content/uploads/2020/07/Gi%E1%BA%A3i-ph%E1%BA%ABu-gan.jpg" style="height:337px; width:600px" /></p>

<p>Giải phẫu gan</p>

<h2>Cung cấp m&aacute;u</h2>

<p>Gan nhận được một nguồn cung cấp m&aacute;u k&eacute;p từ tĩnh mạch cửa v&agrave; động mạch gan. Tĩnh mạch cửa cung cấp khoảng 75% lượng m&aacute;u cung cấp cwho gan v&agrave; mang m&aacute;u tĩnh mạch tho&aacute;t ra từ l&aacute;ch, đường ti&ecirc;u h&oacute;a v&agrave; c&aacute;c cơ quan li&ecirc;n quan. C&aacute;c động mạch gan cung cấp m&aacute;u cho gan, chiếm một phần tư lưu lượng m&aacute;u c&ograve;n lại của gan.</p>

<p>Oxy được cung cấp từ cả hai nguồn. Khoảng một nửa nhu cầu oxy của gan được cung cấp bởi tĩnh mạch cửa v&agrave; một nửa được cung cấp bởi c&aacute;c động mạch gan. Động mạch gan cũng c&oacute; cả thụ thể alpha v&agrave; beta-adrenergic. Do đ&oacute;, d&ograve;ng m&aacute;u động mạch được kiểm so&aacute;t một phần bởi c&aacute;c d&acirc;y thần kinh li&ecirc;n sườn của hệ thống thần kinh tự trị.</p>

<p>M&aacute;u chảy qua c&aacute;c xoang gan v&agrave; v&agrave;o tĩnh mạch trung t&acirc;m của mỗi th&ugrave;y. C&aacute;c tĩnh mạch trung t&acirc;m kết hợp th&agrave;nh c&aacute;c tĩnh mạch gan v&agrave; chảy v&agrave;o tĩnh mạch chủ dưới.</p>

<p><a href="https://youmed.vn/tin-tuc/diep-ha-chau-thao-duoc-co-tac-dung-bao-ve-la-gan/">Diệp hạ ch&acirc;u</a>&nbsp;đắng hay c&ograve;n được gọi l&agrave; Ch&oacute; đẻ th&acirc;n xanh, t&ecirc;n khoa học l&agrave; Phyllanthus amarus Schum. Et Thonn, thuộc họ Thầu dầu (Euphorbiaceae). Đ&acirc;y l&agrave; vị thuốc được sử dụng nhiều trong d&acirc;n gian để điều trị c&aacute;c bệnh về gan.</p>

<h2>Chức năng</h2>

<p>C&aacute;c chức năng kh&aacute;c nhau của n&oacute; được thực hiện bởi c&aacute;c tế b&agrave;o gan. N&oacute; được cho l&agrave; chịu tr&aacute;ch nhiệm tới 500 chức năng ri&ecirc;ng biệt, thường l&agrave; kết hợp với c&aacute;c hệ thống v&agrave; cơ quan kh&aacute;c. Hiện tại, kh&ocirc;ng c&oacute; cơ quan hoặc thiết bị nh&acirc;n tạo n&agrave;o c&oacute; khả năng t&aacute;i tạo tất cả c&aacute;c chức năng của gan. N&oacute; chiếm khoảng 20% ​​tổng lượng oxy ti&ecirc;u thụ của cơ thể khi nghỉ ngơi.</p>

<h3>Tổng hợp</h3>

<p>N&oacute; đ&oacute;ng vai tr&ograve; ch&iacute;nh trong chuyển h&oacute;a carbohydrate, protein, axit amin v&agrave; lipid.</p>

<p>1. Chuyển h&oacute;a carbohydrate</p>

<p>Gan thực hiện một số vai tr&ograve; trong chuyển h&oacute;a carbohydrate</p>

<p>N&oacute; tổng hợp v&agrave; lưu trữ khoảng 100 g glycogen th&ocirc;ng qua qu&aacute; tr&igrave;nh glycogenesis &ndash; sự h&igrave;nh th&agrave;nh glycogen từ glucose. Khi cần, gan giải ph&oacute;ng glucose v&agrave;o m&aacute;u bằng c&aacute;ch thực hiện qu&aacute; tr&igrave;nh glycogenolysis &ndash; ph&acirc;n hủy glycogen th&agrave;nh glucose. N&oacute; cũng chịu tr&aacute;ch nhiệm cho qu&aacute; tr&igrave;nh gluconeogenesis, đ&oacute; l&agrave; sự tổng hợp glucose từ một số axit amin, lactate hoặc glycerol. M&ocirc; mỡ v&agrave; tế b&agrave;o gan sản xuất glycerol bằng c&aacute;ch ph&acirc;n hủy chất b&eacute;o m&agrave; gan sử dụng cho qu&aacute; tr&igrave;nh gluconeogenesis.</p>

<p>2. Chuyển h&oacute;a protein</p>

<p>Gan chịu tr&aacute;ch nhiệm ch&iacute;nh cho qu&aacute; tr&igrave;nh chuyển h&oacute;a protein, tổng hợp cũng như tho&aacute;i h&oacute;a. N&oacute; cũng chịu tr&aacute;ch nhiệm cho một phần lớn tổng hợp axit amin. N&oacute; đ&oacute;ng vai tr&ograve; trong việc sản xuất c&aacute;c yếu tố đ&ocirc;ng m&aacute;u, cũng như sản xuất hồng cầu.</p>

<p>Một số protein được gan tổng hợp bao gồm c&aacute;c yếu tố đ&ocirc;ng m&aacute;u I (fibrinogen), II (prothrombin), V, VII, VIII, IX, X, XI, XII, XIII, cũng như protein C, protein S v&agrave; antithrombin. Trong ba th&aacute;ng đầu của thai nhi, gan l&agrave; nơi sản xuất hồng cầu ch&iacute;nh. Đến tuần thứ 32 của thai kỳ, tủy xương gần như ho&agrave;n to&agrave;n đảm nhận nhiệm vụ n&agrave;y. N&oacute; cũng&nbsp; l&agrave; nơi sản xuất ch&iacute;nh thrombopoietin, một loại glycoprotein điều chỉnh việc sản xuất tiểu cầu bằng tủy xương.</p>

<p>3. Chuyển h&oacute;a lipid</p>

<p>N&oacute; gi&uacute;p tổng hợp cholesterol, tạo lipid v&agrave; sản xuất triglyceride. V&agrave; một phần lớn lipoprotein của cơ thể được tổng hợp ở gan. Gan đ&oacute;ng vai tr&ograve; ch&iacute;nh trong qu&aacute; tr&igrave;nh ti&ecirc;u h&oacute;a, v&igrave; n&oacute; tạo ra v&agrave; b&agrave;i tiết mật cần thiết để nhũ h&oacute;a chất b&eacute;o v&agrave; gi&uacute;p hấp thu vitamin K từ chế độ ăn uống. Một số dịch mật chảy trực tiếp v&agrave;o t&aacute; tr&agrave;ng, v&agrave; một số được lưu trữ trong t&uacute;i mật. N&oacute; cũng tạo ra yếu tố tăng trưởng giống như insulin 1, hormone protein polypeptide đ&oacute;ng vai tr&ograve; quan trọng trong sự tăng trưởng của trẻ em v&agrave; tiếp tục c&oacute; t&aacute;c dụng đồng h&oacute;a ở người lớn.</p>

<h3>Ph&acirc;n hủy</h3>

<p>Gan ph&aacute; vỡ bilirubin th&ocirc;ng qua qu&aacute; tr&igrave;nh glucuronidation, gi&uacute;p b&agrave;i tiết ch&uacute;ng v&agrave;o mật. N&oacute; chịu tr&aacute;ch nhiệm cho sự ph&acirc;n hủy v&agrave; b&agrave;i tiết của nhiều chất thải. N&oacute; đ&oacute;ng một vai tr&ograve; quan trọng trong việc chuyển h&oacute;a c&aacute;c chất độc hại (v&iacute; dụ, methyl h&oacute;a) v&agrave; hầu hết c&aacute;c sản phẩm thuốc trong một qu&aacute; tr&igrave;nh gọi l&agrave; chuyển h&oacute;a thuốc. Điều n&agrave;y đ&ocirc;i khi dẫn đến độc t&iacute;nh, khi chất chuyển h&oacute;a độc hơn so với tiền chất của n&oacute;. C&aacute;c độc tố sẽ được kết hợp với c&aacute;c chất hoặc được ph&acirc;n hủy để b&agrave;i tiết qua mật hoặc nước tiểu. N&oacute; chuyển đổi amoniac th&agrave;nh ur&ecirc; như một phần của chu tr&igrave;nh ur&ecirc; v&agrave; ur&ecirc; được b&agrave;i tiết qua nước tiểu.</p>

<h3>Hồ chứa m&aacute;u</h3>

<p>Một lượng lớn m&aacute;u c&oacute; thể được lưu trữ trong c&aacute;c mạch m&aacute;u của gan. Lượng m&aacute;u b&igrave;nh thường của n&oacute;, bao gồm cả trong c&aacute;c tĩnh mạch gan v&agrave; trong xoang gan, l&agrave; khoảng 450 ml, chiếm gần 10% tổng lượng m&aacute;u của cơ thể. Khi &aacute;p lực cao ở t&acirc;m nhĩ phải g&acirc;y tăng &aacute;p lực trong gan, gan sẽ gi&atilde;n ra v&agrave; chứa đến 0,5 đến 1 l&iacute;t m&aacute;u thừa đ&ocirc;i khi được lưu trữ trong c&aacute;c tĩnh mạch gan v&agrave; xoang gan . Điều n&agrave;y xảy ra đặc biệt trong suy tim sung huyết.</p>

<h3>Kh&aacute;c</h3>

<p>Gan lưu trữ v&ocirc; số c&aacute;c chất, bao gồm vitamin A (cung cấp khoảng 1- 2 năm),&nbsp;<a href="https://youmed.vn/tin-tuc/vitamin-d-vai-tro-lieu-luong-va-cach-bo-sung/" target="_blank">vitamin D</a>&nbsp;(cung cấp khoảng 1 &ndash; 4 th&aacute;ng), vitamin B12 (cung cấp 3- 5 năm), vitamin K,&nbsp;<a href="https://youmed.vn/tin-tuc/nhung-thuc-pham-giau-chat-sat-ma-ban-can-biet/" target="_blank">sắt</a>&nbsp;v&agrave; đồng.</p>

<p>N&oacute; cũng chịu tr&aacute;ch nhiệm về c&aacute;c phản ứng miễn dịch &ndash; hệ thống trong cơ thể.</p>

<p>Gan sản xuất albumin, globulin miễn dịch. N&oacute; cũng sản xuất enzyme catalase để ph&aacute; vỡ hydro peroxide, một t&aacute;c nh&acirc;n oxy h&oacute;a độc hại, th&agrave;nh nước v&agrave; oxy.</p>

<h2>C&aacute;c bệnh l&yacute; về gan</h2>

<p>Vi&ecirc;m gan: Vi&ecirc;m gan thường do c&aacute;c loại virus như vi&ecirc;m gan A, B v&agrave; C. Vi&ecirc;m gan c&oacute; thể c&oacute; nguy&ecirc;n nh&acirc;n kh&ocirc;ng nhiễm tr&ugrave;ng, bao gồm uống nhiều rượu, thuốc, phản ứng dị ứng hoặc b&eacute;o ph&igrave;.</p>

<p><a href="https://youmed.vn/tin-tuc/xo-gan-la-gi-xo-gan-co-nhung-bieu-hien-nao/">Xơ gan</a>: Tổn thương gan l&acirc;u d&agrave;i do mọi nguy&ecirc;n nh&acirc;n c&oacute; thể dẫn đến sẹo vĩnh viễn, được gọi l&agrave; xơ gan. Gan sau đ&oacute; trở n&ecirc;n kh&ocirc;ng thể hoạt động tốt.</p>

<p><a href="https://youmed.vn/tin-tuc/ung-thu-gan-dac-diem-nguyen-nhan-va-cach-nhan-biet-benh/">Ung thư gan</a>: Loại ung thư gan phổ biến nhất l&agrave; ung thư biểu m&ocirc; tế b&agrave;o gan.</p>

<p><a href="https://youmed.vn/tin-tuc/suy-gan/">Suy gan</a>: Suy gan c&oacute; nhiều nguy&ecirc;n nh&acirc;n bao gồm nhiễm tr&ugrave;ng, bệnh di truyền v&agrave; uống rượu qu&aacute; mức</p>

<p>Xơ gan cổ trướng: Khi xơ gan, gan r&ograve; rỉ chất lỏng (cổ trướng) v&agrave;o bụng, khiến bụng trở n&ecirc;n căng v&agrave; ph&igrave;nh to.</p>

<p><a href="https://youmed.vn/tin-tuc/soi-tui-mat-nguyen-nhan-va-trieu-chung/">Sỏi mật</a>: Nếu sỏi mật bị kẹt trong ống mật dẫn lưu gan, vi&ecirc;m gan v&agrave; nhiễm tr&ugrave;ng ống mật (vi&ecirc;m đường mật) c&oacute; thể xảy ra.</p>

<p>Hemochromatosis: Hemochromatosis l&agrave; t&igrave;nh trạng sắt lắng đọng trong gan, g&acirc;y hại cho gan. Chất sắt cũng lắng đọng khắp cơ thể, g&acirc;y ra nhiều vấn đề sức khỏe kh&aacute;c.</p>

<p>Vi&ecirc;m đường mật xơ h&oacute;a nguy&ecirc;n ph&aacute;t: Một bệnh hiếm gặp kh&ocirc;ng r&otilde; nguy&ecirc;n nh&acirc;n, vi&ecirc;m đường mật xơ h&oacute;a nguy&ecirc;n ph&aacute;t g&acirc;y vi&ecirc;m v&agrave; sẹo trong c&aacute;c ống mật trong gan.</p>

<p><img alt="Gan khỏe mạnh và gan bị xơ" src="https://cdn.youmed.vn/tin-tuc/wp-content/uploads/2020/07/H-13.jpg" style="height:299px; width:600px" /></p>

<p>Gan khỏe mạnh v&agrave; gan bị xơ</p>

<h2>X&eacute;t nghiệm bệnh l&yacute; gan</h2>

<h3>X&eacute;t nghiệm m&aacute;u</h3>

<p>C&aacute;c x&eacute;t nghiệm cho thấy chức năng gan hoạt động như thế n&agrave;o. Bao gồm nhiều x&eacute;t nghiệm m&aacute;u kh&aacute;c nhau:</p>

<ul>
	<li>ALT (Alanine Aminotransferase): ALT tăng gi&uacute;p x&aacute;c định bệnh gan hoặc tổn thương gan do bất kỳ nguy&ecirc;n nh&acirc;n n&agrave;o, bao gồm cả vi&ecirc;m gan.</li>
	<li>AST (Aspartate Aminotransferase): C&ugrave;ng với ALT tăng, AST kiểm tra t&igrave;nh trạng tổn thương gan.</li>
	<li>Phosphatase kiềm: Phosphatase kiềm c&oacute; trong c&aacute;c tế b&agrave;o tiết mật trong gan; n&oacute; cũng ở trong xương. Mức độ cao thường c&oacute; nghĩa l&agrave; d&ograve;ng mật ra khỏi gan bị tắc nghẽn.</li>
	<li>Bilirubin: Nồng độ bilirubin cao cho thấy c&oacute; vấn đề với chuyển h&oacute;a, tắc nghẽn mật.</li>
	<li>Albumin: được tổng hợp ở gan, albumin gi&uacute;p x&aacute;c định chức năng tổng hợp của n&oacute; hoạt động tốt như thế n&agrave;o.</li>
	<li>Amoniac: Nồng độ amoniac trong m&aacute;u tăng khi gan kh&ocirc;ng hoạt động tốt.</li>
	<li>X&eacute;t nghiệm vi&ecirc;m gan A: Nếu nghi ngờ , b&aacute;c sĩ sẽ kiểm tra chức năng gan cũng như kh&aacute;ng thể để ph&aacute;t hiện virus vi&ecirc;m gan A.</li>
	<li>Vi&ecirc;m gan B: B&aacute;c sĩ c&oacute; thể kiểm tra nồng độ kh&aacute;ng thể để x&aacute;c định xem bạn c&oacute; bị nhiễm vi r&uacute;t vi&ecirc;m gan B hay kh&ocirc;ng.</li>
	<li>X&eacute;t nghiệm vi&ecirc;m gan C: Ngo&agrave;i việc kiểm tra chức năng gan, x&eacute;t nghiệm m&aacute;u c&oacute; thể x&aacute;c định xem bạn c&oacute; bị nhiễm vi r&uacute;t vi&ecirc;m gan C hay kh&ocirc;ng.</li>
	<li>Thời gian prothrombin (PT): Thời gian prothrombin, hoặc PT, thường được thực hiện để xem bạn c&oacute; đang d&ugrave;ng đ&uacute;ng liều warfarin kh&ocirc;ng (thuốc l&agrave;m lo&atilde;ng m&aacute;u) . N&oacute; cũng kiểm tra c&aacute;c vấn đề t&igrave;nh trạng đ&ocirc;ng m&aacute;u.</li>
	<li>Thời gian Thromboplastin (APTT): APTT được thực hiện để kiểm tra c&aacute;c vấn đề đ&ocirc;ng m&aacute;u.</li>
</ul>

<h3>X&eacute;t nghiệm h&igrave;nh ảnh</h3>

<ul>
	<li>Si&ecirc;u &acirc;m: Si&ecirc;u &acirc;m bụng c&oacute; thể kiểm tra t&igrave;nh trạng gan, bao gồm ung thư, xơ gan hoặc c&aacute;c vấn đề từ sỏi mật.</li>
	<li>CT scan (chụp cắt lớp vi t&iacute;nh): Chụp CT bụng cho h&igrave;nh ảnh chi tiết về gan v&agrave; c&aacute;c cơ quan bụng kh&aacute;c.</li>
	<li>Sinh thiết: Sinh thiết gan được thực hiện sau một x&eacute;t nghiệm kh&aacute;c, chẳng hạn như x&eacute;t nghiệm m&aacute;u hoặc si&ecirc;u &acirc;m, cho thấy c&oacute; vấn đề về gan.</li>
</ul>

<p><strong>Gan</strong>&nbsp;l&agrave; cơ quan qu&yacute; gi&aacute; của cơ thể, tham gia v&agrave;o nhiều vai tr&ograve;, gi&uacute;p cơ thể hoạt động tốt.&nbsp;<a href="https://youmed.vn/tin-tuc/hoi-chung-gan-phoi-dinh-nghia-dau-hieu-chan-doan-va-phuong-phap-dieu-tri/">Hội chứng gan phổi</a>&nbsp;l&agrave; một vấn đề sức khỏe hiếm gặp. Hội chứng n&agrave;y được g&acirc;y ra do mạch m&aacute;u trong phổi bị d&atilde;n ra. Hội chứng gan phổi đưa đến t&igrave;nh trạng kh&oacute; thở do nồng độ oxy thấp trong m&aacute;u. Hiện nay, phương ph&aacute;p điều trị duy nhất l&agrave; gh&eacute;p gan.</p>
', '2025-07-14 18:00:25', '2025-07-19 14:06:24', 4);
INSERT INTO swp_db.news (id, title, image_preview, short_description, description, created_at, updated_at, created_by)
VALUES ( 7, 'Tin vui: Mở rộng độ tuổi tiêm phòng HPV đến 45 tuổi'
       , 'https://cdn.youmed.vn/tin-tuc/wp-content/uploads/2024/05/chi-dinh-vac-xin-hpv-1-768x512.jpg'
       , 'Ngày 09/05/2024 vừa qua, Bộ Y tế Việt Nam đã chính thức chấp thuận mở rộng độ tuổi tiêm chủng vắc xin HPV đến 45 tuổi. Đây được xem là một bước tiến quan trọng cho việc bảo vệ sức khỏe cộng đồng và phòng ngừa hiệu quả bệnh ung thư cổ tử cung, cũng như các bệnh ung thư liên quan HPV ở nam và nữ.'
       , '<h2>Chỉ định mở rộng độ tuổi ti&ecirc;m vắc xin HPV đến 45 tuổi</h2>

<p>Theo Tổ chức Y tế Thế giới (WHO),&nbsp;<a href="https://youmed.vn/tin-tuc/hpv-virus-la-gi-co-bao-nhieu-chung-virus-hpv/">HPV</a>&nbsp;được xem l&agrave; nguy&ecirc;n nh&acirc;n ch&iacute;nh của hơn 90% trường hợp&nbsp;<a href="https://youmed.vn/tin-tuc/ung-thu-co-tu-cung-co-nguy-hiem-khong/">ung thư cổ tử cung</a>&nbsp;ở nữ giới.<a href="https://youmed.vn/tin-tuc/tin-vui-mo-rong-do-tuoi-tiem-phong-hpv-den-45-tuoi/#cite-1">1</a>&nbsp;Tại Việt Nam, ung thư cổ tử cung được xếp v&agrave;o loại ung thư phổ biến thứ 8 v&agrave; hơn 39,1 triệu phụ nữ tr&ecirc;n 15 tuổi c&oacute; nguy cơ ph&aacute;t triển loại ung thư n&agrave;y, theo số liệu thống k&ecirc; của Trung t&acirc;m Th&ocirc;ng tin HPV (HPV Information Centre).<a href="https://youmed.vn/tin-tuc/tin-vui-mo-rong-do-tuoi-tiem-phong-hpv-den-45-tuoi/#cite-2">2</a></p>

<p>Kh&ocirc;ng chỉ vậy, 60% trường hợp&nbsp;<a href="https://youmed.vn/tin-tuc/ung-thu-duong-vat/">ung thư dương vật</a>&nbsp;ở nam giới v&agrave; nhiều bệnh ung thư sinh dục kh&aacute;c cũng c&oacute; sự li&ecirc;n quan với HPV.<a href="https://youmed.vn/tin-tuc/tin-vui-mo-rong-do-tuoi-tiem-phong-hpv-den-45-tuoi/#cite-3">3</a>&nbsp;<a href="https://youmed.vn/tin-tuc/tiem-phong-hpv-ngua-ung-thu-co-tu-cung/">Ti&ecirc;m vắc xin HPV</a>&nbsp;l&agrave; liệu ph&aacute;p hiệu quả để chủ động bảo vệ cơ thể trước c&aacute;c bệnh nguy hiểm tiềm t&agrave;ng g&acirc;y ra bởi HPV.</p>

<p><img alt="Chủ động tiêm vắc xin HPV để bảo vệ bản thân" src="https://cdn.youmed.vn/tin-tuc/wp-content/uploads/2024/05/chi-dinh-vac-xin-hpv-1.jpg" style="height:400px; width:600px" /></p>

<p>Chủ động ti&ecirc;m vắc xin HPV để bảo vệ bản th&acirc;n</p>

<p>Trong c&ocirc;ng văn 10494e/QLD-ĐK mới đ&acirc;y, Bộ Y tế đ&atilde; ch&iacute;nh thức chỉ định độ tuổi ti&ecirc;m vắc xin ngừa HPV từ 9-45 tuổi, rộng hơn so với khuyến nghị 9-26 tuổi trước đ&acirc;y. Điều n&agrave;y gi&uacute;p cả nam v&agrave; nữ ở nhiều độ tuổi c&oacute; th&ecirc;m cơ hội tiếp cận giải ph&aacute;p ph&ograve;ng ngừa bệnh an to&agrave;n n&agrave;y.</p>

<h2>Gardasil 9 v&agrave; tiềm năng miễn dịch cộng đồng HPV</h2>

<p>Trước đ&acirc;y,&nbsp;<a href="https://youmed.vn/tin-tuc/vac-xin-hpv/">vắc xin HPV</a>&nbsp;thường chỉ được chỉ định cho độ tuổi từ 9-26 tuổi. Tuy nhi&ecirc;n, với c&ocirc;ng bố ch&iacute;nh thức của Bộ Y tế vừa rồi, cả cộng đồng bất kể nam hay nữ từ 9-45 tuổi đều c&oacute; thể ph&ograve;ng ngừa HPV hiệu quả nhờ loại vắc xin Gardasil 9.</p>

<p>Vắc xin Gardasil 9 được nghi&ecirc;n cứu v&agrave; ph&aacute;t triển bởi tập đo&agrave;n h&agrave;ng đầu thế giới về dược phẩm v&agrave; chế phẩm sinh học Merck Sharp &amp; Dohme (MSD &ndash; Mỹ) . Đ&acirc;y l&agrave; vắc xin ti&ecirc;m bắp t&aacute;i tổ hợp gi&uacute;p ph&ograve;ng ngừa 9 chủng HPV phổ biến, với hiệu quả l&ecirc;n đến hơn 98% sau 1 th&aacute;ng ti&ecirc;m.<a href="https://youmed.vn/tin-tuc/tin-vui-mo-rong-do-tuoi-tiem-phong-hpv-den-45-tuoi/#cite-4">4</a></p>

<p>Cụ thể, Gardasil 9 bảo vệ cơ thể trước HPV tu&yacute;p 6, 11, 16, 18, 31, 33, 45, 52 v&agrave; 58 &ndash; nguy&ecirc;n nh&acirc;n ch&iacute;nh g&acirc;y ra 70% ca ung thư c&ocirc;̉ tử cung v&agrave; c&aacute;c bệnh nguy hiểm kh&aacute;c như&nbsp;<a href="https://youmed.vn/tin-tuc/ung-thu-am-ho-cach-nhan-biet-trieu-chung-va-phong-ngua/">ung thư &acirc;m hộ</a>,&nbsp;<a href="https://youmed.vn/tin-tuc/ung-thu-am-dao/">ung thư &acirc;m đạo</a>,&nbsp;<a href="https://youmed.vn/tin-tuc/ung-thu-hau-mon/">ung thư hậu m&ocirc;n</a>, ung thư h&acirc;̀u họng, mụn cóc sinh dục ở cả nam v&agrave; nữ.<a href="https://youmed.vn/tin-tuc/tin-vui-mo-rong-do-tuoi-tiem-phong-hpv-den-45-tuoi/#cite-5">5</a></p>

<p>Việc mở rộng độ tuổi ti&ecirc;m chủng vắc xin HPV mở ra nhiều cơ hội hơn cho cộng đồng trong việc bảo vệ bản th&acirc;n v&agrave; những người xung quanh. Đừng qu&ecirc;n tham khảo th&ecirc;m th&ocirc;ng tin về HPV tại website ch&iacute;nh thống để tăng cường hiểu biết cho ch&iacute;nh m&igrave;nh v&agrave; người th&acirc;n.</p>
', '2025-07-19 01:38:08', '2025-07-19 14:01:51', 4);
INSERT INTO swp_db.news (id, title, image_preview, short_description, description, created_at, updated_at, created_by)
VALUES ( 8, 'Thuốc Klamentin gói là thuốc gì? Công dụng, cách dùng và lưu ý sử dụng'
       , 'https://cdn.youmed.vn/tin-tuc/wp-content/uploads/2024/05/thuoc-klamentin-goi-3.jpg'
       , 'Cốm pha hỗn dịch uống Klamentin, hay thường được gọi là thuốc Klamentin gói, là thuốc kháng sinh được dùng trong điều trị nhiễm khuẩn. Vậy thuốc Klamentin được sử dụng cụ thể trong trường hợp nào? Cách dùng thuốc hợp lý ra sao? Cùng Dược sĩ Bùi Hoàng Ngọc Khánh tìm hiểu về loại thuốc này qua bài viết dưới đây.'
       , '<p><em>Hoạt chất:</em>&nbsp;Amoxicillin v&agrave; acid clavulanic.</p>

<h2>Thuốc Klamentin g&oacute;i l&agrave; thuốc g&igrave;?</h2>

<p>Klamentin được sản xuất bởi c&ocirc;ng ty Cổ phần Dược Hậu Giang (DHG Pharma). Thuốc c&oacute; th&agrave;nh phần ch&iacute;nh l&agrave; amoxicillin v&agrave; acid clavulanic.</p>

<p>Thuốc Klamentin g&oacute;i, hay cốm pha hỗn dịch uống được b&agrave;o chế với nhiều dạng h&agrave;m lượng kh&aacute;c nhau bao gồm 500/62.5 mg hay 250/31.25 mg. Klamentin thuộc nh&oacute;m thuốc b&aacute;n cần k&ecirc; đơn.</p>

<h3>Dạng b&agrave;o chế</h3>

<p>Thuốc cốm pha hỗn dịch uống.</p>

<h3>Quy c&aacute;ch đ&oacute;ng g&oacute;i</h3>

<ul>
	<li>Klamentin 250/31.25: Hộp 24 g&oacute;i x 1 g.</li>
	<li>Klamentin 500/62.5: Hộp 24 g&oacute;i x 2 g.</li>
</ul>

<h2>Th&agrave;nh phần của cốm pha hỗn dịch uống Klamentin</h2>

<p>Th&agrave;nh phần ch&iacute;nh trong thuốc Klamentin l&agrave; amoxicillin v&agrave; acid clavulanic.</p>

<p>Trong đ&oacute;, amoxicillin l&agrave; một kh&aacute;ng sinh b&aacute;n tổng hợp thuộc họ beta-lactam. N&oacute; c&oacute; phổ diệt khuẩn rộng, t&aacute;c dụng chống lại nhiều vi khuẩn gram dương v&agrave; gram &acirc;m.</p>

<p>Acid clavulanic l&agrave; chất ức chế enzym beta-lactamase &ndash; được tiết ra từ c&aacute;c vi khuẩn th&ocirc;ng thường đ&atilde; kh&aacute;ng lại amoxicilin, c&aacute;c penicilin kh&aacute;c v&agrave; c&aacute;c cephalosporin. Acid clavulanic được kết hợp với amoxicilin gi&uacute;p bảo vệ amoxicilin kh&ocirc;ng bị beta-lactamase ph&aacute; hủy.</p>

<p>H&agrave;m lượng hoạt chất trong từng đơn vị liều cũng thay đổi, tương ứng với mỗi dạng b&agrave;o chế. Điều n&agrave;y gi&uacute;p c&aacute; nh&acirc;n h&oacute;a khả năng điều trị của thuốc cho từng đối tượng người bệnh:</p>

<ul>
	<li>Klamentin 250/31.25 chứa 250 mg amoxicillin v&agrave; 31,25 mg acid clavulanic.<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-1">1</a></li>
	<li>Klamentin 500/62.5 chứa 500 mg amoxicillin v&agrave; 62,5 mg acid clavulanic.<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-2">2</a></li>
</ul>

<p><img alt="Cốm pha hỗn dịch uống Klamentin 250/31.25 chứa 250 mg amoxicillin và 31.25 mg acid clavulanic" src="https://cdn.youmed.vn/tin-tuc/wp-content/uploads/2024/05/thuoc-klamentin-goi-3.jpg" style="height:346px; width:600px" /></p>

<p>Cốm pha hỗn dịch uống Klamentin 250/31.25 chứa 250 mg amoxicillin v&agrave; 31.25 mg acid clavulanic</p>

<p><img alt="Cốm pha hỗn dịch uống Klamentin 500/62.5 chứa 500 mg amoxicillin và 62.5 mg acid clavulanic" src="https://cdn.youmed.vn/tin-tuc/wp-content/uploads/2024/05/thuoc-klamentin-goi-2.jpg" style="height:419px; width:600px" /></p>

<p>Cốm pha hỗn dịch uống Klamentin 500/62.5 chứa 500 mg amoxicillin v&agrave; 62.5 mg acid clavulanic</p>

<h2>C&ocirc;ng dụng của th&agrave;nh phần c&oacute; trong Klamentin</h2>

<h3>Dược lực học</h3>

<p>Amoxicillin diệt khuẩn bằng c&aacute;ch k&igrave;m h&atilde;m qu&aacute; tr&igrave;nh sinh tổng hợp lớp peptidoglycan của th&agrave;nh tế b&agrave;o vi khuẩn. Điều n&agrave;y dẫn đến sự ph&aacute; huỷ hoặc ly giải vi khuẩn.<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-3">3</a></p>

<p>Nhiều năm qua, một số vi khuẩn đ&atilde; ph&aacute;t triển khả năng kh&aacute;ng thuốc kh&aacute;ng sinh họ beta-lactam th&ocirc;ng qua việc sản xuất enzyme beta-lactamase.<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-3">3</a></p>

<p>Amoxicillin dễ bị ph&aacute; hủy bởi beta &ndash; lactamase. V&igrave; thế n&oacute; kh&ocirc;ng c&oacute; t&aacute;c dụng đối với những chủng vi khuẩn sản sinh ra c&aacute;c enzym n&agrave;y.</p>

<p>Axit clavulanic c&oacute; khả năng ức chế beta-lactamase. V&igrave; thế, n&oacute; thường được sử dụng kết hợp với amoxicillin để mở rộng phổ t&aacute;c dụng v&agrave; ngăn chặn t&igrave;nh trạng kh&aacute;ng thuốc. Axit clavulanic c&oacute; rất &iacute;t hoặc kh&ocirc;ng c&oacute; hoạt t&iacute;nh kh&aacute;ng khuẩn. Thay v&agrave;o đ&oacute;, n&oacute; hoạt động bằng c&aacute;ch ngăn chặn vi khuẩn ph&aacute; hủy kh&aacute;ng sinh beta-lactam.<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-3">3</a></p>

<p>Trong Klamentin, sự kết hợp acid clavulanic v&agrave; amoxicilin kh&ocirc;ng chỉ gi&uacute;p amoxicilin kh&ocirc;ng bị ph&aacute; hủy bởi beta &ndash; lactamase, m&agrave; c&ograve;n mở rộng th&ecirc;m phổ kh&aacute;ng khuẩn của amoxicillin hiệu quả đối với nhiều vi khuẩn th&ocirc;ng thường đ&atilde; kh&aacute;ng lại amoxicilin, c&aacute;c penicilin kh&aacute;c v&agrave; c&aacute;c cephalosporin.<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-1">1</a>&nbsp;<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-2">2</a></p>

<p>Phổ diệt khuẩn của thuốc bao gồm:</p>

<table>
	<tbody>
		<tr>
			<td><strong>Vi khuẩn gram dương</strong></td>
			<td><strong>Vi khuẩn gram &acirc;m</strong></td>
		</tr>
		<tr>
			<td>
			<ul>
				<li>Loại hiếu kh&iacute;:&nbsp;<em>Streptococcus faecalis</em>,&nbsp;<em>Streptococcus pneumoniae</em>,&nbsp;<em>Streptococcus pyogenes</em>,&nbsp;<em>Streptococcus viridans</em>,&nbsp;<em>Staphylococcus aureus</em>,&nbsp;<em>Corynebacterium</em>,&nbsp;<em>Bacillus anthracis</em>,&nbsp;<em>Listeria monocytogenes</em>.</li>
				<li>Loại yếm kh&iacute;: C&aacute;c lo&agrave;i&nbsp;<em>Clostridium</em>,&nbsp;<em>Peptococcus</em>,&nbsp;<em>Peptostreptococcus</em>.</li>
			</ul>
			</td>
			<td>
			<ul>
				<li>Loại hiếu kh&iacute;:&nbsp;<em>Haemophilus influenzae</em>,&nbsp;<em>Escherichia coli</em>,&nbsp;<em>Proteus mirabilis</em>,&nbsp;<em>Proteus vulgaris</em>, c&aacute;c lo&agrave;i&nbsp;<em>Klebsiella</em>,&nbsp;<em>Salmonella</em>,&nbsp;<em>Shigella</em>,&nbsp;<em>Bordetella</em>,&nbsp;<em>Neisseria gonorrhoeae</em>,&nbsp;<em>Neisseria meningitidis</em>,&nbsp;<em>Vibrio cholerae</em>,&nbsp;<em>Pasteurella multocida</em>.</li>
				<li>Loại yếm kh&iacute;: C&aacute;c lo&agrave;i&nbsp;<em>Bacteroides</em>&nbsp;kể cả&nbsp;<em>B. fragilis</em>.</li>
			</ul>
			</td>
		</tr>
	</tbody>
</table>

<h3>Dược động học<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-1">1</a>&nbsp;<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-2">2</a></h3>

<p>Amoxicillin v&agrave; acid clavulanic đều hấp thu dễ d&agrave;ng qua đường uống. Nồng độ tối đa của thuốc trong m&aacute;u đạt được sau 1 &ndash; 2 giờ.</p>

<p>Sự hấp thu của thuốc kh&ocirc;ng bị ảnh hưởng bởi thức ăn. Tốt nhất l&agrave; uống thuốc ngay trước bữa ăn. Sinh khả dụng đường uống của amoxicillin l&agrave; 90% v&agrave; của acid clavulanic l&agrave; 75%.</p>

<p>Thời gian b&aacute;n thải của amoxicillin trong m&aacute;u l&agrave; 1 &ndash; 2 giờ v&agrave; của acid clavulanic l&agrave; khoảng 1 giờ. 55 &ndash; 70% amoxicillin v&agrave; 30 &ndash; 40% acid clavulanic được thải qua nước tiểu dưới dạng hoạt động.</p>

<p>Probenecid k&eacute;o d&agrave;i thời gian đ&agrave;o thải của amoxicillin nhưng kh&ocirc;ng ảnh hưởng đến sự đ&agrave;o thải của acid clavulanic.</p>

<h2>T&aacute;c dụng của thuốc Klamentin</h2>

<p>Klamentin điều trị ngắn hạn c&aacute;c nhiễm khuẩn đường h&ocirc; hấp tr&ecirc;n v&agrave; dưới, đường tiết niệu, da v&agrave; m&ocirc; mềm, xương v&agrave; khớp.<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-1">1</a>&nbsp;<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-2">2</a></p>

<p>Klamentin c&oacute; t&iacute;nh diệt khuẩn với nhiều loại vi khuẩn, kể cả c&aacute;c d&ograve;ng tiết beta &ndash; lactamase đề kh&aacute;ng với ampicilin v&agrave; amoxicilin.</p>

<h2>C&aacute;ch d&ugrave;ng v&agrave; liều d&ugrave;ng thuốc Klamentin g&oacute;i</h2>

<h3>1. C&aacute;ch d&ugrave;ng<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-1">1</a>&nbsp;<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-2">2</a></h3>

<p>H&ograve;a thuốc với lượng nước vừa đủ (khoảng 5 &ndash; 10 ml nước cho 1 g&oacute;i), khuấy đều trước khi uống.</p>

<p>Uống thuốc ngay trước bữa ăn để giảm thiểu hiện tượng kh&ocirc;ng dung nạp thuốc ở dạ d&agrave;y &ndash; ruột.</p>

<h3>2. Liều d&ugrave;ng<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-1">1</a>&nbsp;<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-2">2</a></h3>

<p>Liều d&ugrave;ng được t&iacute;nh theo amoxicilin.</p>

<p>Trẻ em từ 3 th&aacute;ng tuổi trở l&ecirc;n:</p>

<ul>
	<li><a href="https://youmed.vn/tin-tuc/dau-hieu-viem-tai-giua/">Vi&ecirc;m tai giữa</a>,&nbsp;<a href="https://youmed.vn/tin-tuc/viem-mui-xoang-viem-xoang-nhung-dieu-ban-can-biet/">vi&ecirc;m xoang</a>, nhiễm khuẩn đường h&ocirc; hấp, nhiễm khuẩn nặng: 45 mg/ kg thể trọng/ ng&agrave;y, chia l&agrave;m 2 lần.</li>
	<li>Nhiễm khuẩn nhẹ: 25 mg/ kg thể trọng/ ng&agrave;y, chia l&agrave;m 2 lần.</li>
</ul>

<p>Trẻ em từ 40 kg trở l&ecirc;n: Uống theo liều người lớn.</p>

<p>Người lớn:</p>

<ul>
	<li>Nhiễm khuẩn nhẹ tới vừa: 1000/125 mg x 2 lần/ ng&agrave;y.</li>
	<li>Nhiễm khuẩn nặng (bao gồm nhiễm khuẩn đường tiết niệu t&aacute;i ph&aacute;t v&agrave; mạn t&iacute;nh, nhiễm khuẩn đường h&ocirc; hấp dưới): 1000/125 mg x 3 lần/ ng&agrave;y.</li>
</ul>

<p>Thời gian điều trị k&eacute;o d&agrave;i từ 5 &ndash; 10 ng&agrave;y. Điều trị kh&ocirc;ng được vượt qu&aacute; 14 ng&agrave;y m&agrave; kh&ocirc;ng kh&aacute;m lại. Sử dụng thuốc theo chỉ dẫn của người c&oacute; chuy&ecirc;n m&ocirc;n.</p>

<h2>T&aacute;c dụng kh&ocirc;ng mong muốn của Klamentin</h2>

<p>C&aacute;c t&aacute;c dụng kh&ocirc;ng mong muốn của Klamentin bao gồm:<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-1">1</a>&nbsp;<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-2">2</a></p>

<ul>
	<li>Thường gặp:&nbsp;<a href="https://youmed.vn/tin-tuc/tieu-chay/">Ti&ecirc;u chảy</a>,&nbsp;<a href="https://youmed.vn/tin-tuc/buon-non-va-non-nhung-dieu-can-biet/">buồn n&ocirc;n v&agrave; n&ocirc;n</a>.</li>
	<li>&Iacute;t gặp: Tăng bạch cầu &aacute;i toan; vi&ecirc;m gan, v&agrave;ng da ứ mật; Ngứa, ban đỏ, ph&aacute;t ban.</li>
	<li>Hiếm gặp:&nbsp;<a href="https://youmed.vn/tin-tuc/nhung-dieu-ban-can-biet-can-het-suc-than-trong-voi-soc-phan-ve/">Phản ứng phản vệ</a>, ph&ugrave; Quincke, giảm tiểu cầu, giảm bạch cầu, thiếu m&aacute;u tan m&aacute;u,&nbsp;<a href="https://youmed.vn/tin-tuc/viem-dai-trang-gia-mac-va-nhung-dieu-can-biet/">vi&ecirc;m đại tr&agrave;ng giả mạc</a>,&nbsp;<a href="https://youmed.vn/tin-tuc/hoi-chung-stevens-johnson/">hội chứng Stevens &ndash; Johnson</a>, vi&ecirc;m thận kẽ.</li>
</ul>

<p>Th&ocirc;ng b&aacute;o cho b&aacute;c sĩ những t&aacute;c dụng kh&ocirc;ng mong muốn gặp phải khi sử dụng thuốc, để c&oacute; c&aacute;ch xử tr&iacute; ph&ugrave; hợp.</p>

<h2>Tương t&aacute;c thuốc</h2>

<p>V&igrave; khả năng c&oacute; thể xảy ra tương t&aacute;c giữa Klamentin v&agrave; một số chất n&ecirc;n thận trọng hoặc hỏi &yacute; kiến nh&acirc;n vi&ecirc;n y tế khi d&ugrave;ng Klamentin đồng thời c&ugrave;ng c&aacute;c thuốc sau:<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-1">1</a>&nbsp;<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-2">2</a></p>

<ul>
	<li>Probenecid: Probenecid l&agrave;m giảm sự b&agrave;i tiết amoxicilin ở ống thận. Do đ&oacute; l&agrave;m gia tăng nồng độ amoxicillin trong m&aacute;u.</li>
	<li>Thuốc chống đ&ocirc;ng m&aacute;u đường uống: Thuốc c&oacute; thể g&acirc;y k&eacute;o d&agrave;i thời gian chảy m&aacute;u v&agrave; đ&ocirc;ng m&aacute;u.</li>
	<li>Thuốc ngừa thai: Thuốc c&oacute; thể l&agrave;m giảm t&aacute;c động của thuốc ngừa thai bằng đường uống.</li>
	<li>Đối tượng chống chỉ định d&ugrave;ng Klamentin</li>
</ul>

<h3>1. Đối tượng chống chỉ định<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-1">1</a>&nbsp;<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-2">2</a></h3>

<p>Kh&ocirc;ng sử dụng thuốc cho c&aacute;c đối tượng:</p>

<ul>
	<li>Mẫn cảm với c&aacute;c penicilin v&agrave; cephalosporin.</li>
	<li><a href="https://youmed.vn/tin-tuc/suy-gan/">Suy gan</a>&nbsp;nặng,&nbsp;<a href="https://youmed.vn/tin-tuc/benh-suy-than/">suy thận</a>&nbsp;nặng.</li>
	<li>Tiền sử bị v&agrave;ng da hay rối loạn chức năng gan khi d&ugrave;ng penicilin.</li>
	<li>Tăng bạch cầu đơn nh&acirc;n nhiễm khuẩn.</li>
</ul>

<h3>2. Phụ nữ c&oacute; thai v&agrave; mẹ cho con b&uacute; c&oacute; sử dụng được Klamentin?</h3>

<p>Thời kỳ mang thai<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-1">1</a>&nbsp;<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-2">2</a></p>

<p>Chưa c&oacute; bằng chứng n&agrave;o về t&aacute;c dụng c&oacute; hại cho thai nhi. Tuy nhi&ecirc;n trong thời kỳ mang thai chỉ n&ecirc;n sử dụng khi thật cần thiết.</p>

<p>Thời kỳ cho con b&uacute;<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-3">3</a></p>

<p>Amoxicillin b&agrave;i tiết qua sữa mẹ. Khi sử dụng thuốc cho mẹ đang cho con b&uacute; c&oacute; thể dẫn đến mẫn cảm ở trẻ sơ sinh (thỉnh thoảng g&acirc;y bồn chồn, ti&ecirc;u chảy v&agrave; ph&aacute;t ban). N&ecirc;n thận trọng khi d&ugrave;ng thuốc trong thời kỳ cho con b&uacute;.</p>

<h3>3. Đối tượng cần thận trọng khi d&ugrave;ng Klamentin</h3>

<p>N&ecirc;n điều chỉnh liều ở bệnh nh&acirc;n suy thận nặng (CrCL &lt; 30 mL/ph&uacute;t).<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-3">3</a></p>

<p>Điều trị k&eacute;o d&agrave;i c&oacute; thể g&acirc;y bội nhiễm.<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-1">1</a>&nbsp;<a href="https://youmed.vn/tin-tuc/thuoc-klamentin-goi/#cite-2">2</a></p>

<h2>Xử l&yacute; khi qu&aacute; liều thuốc</h2>

<p>Khi d&ugrave;ng qu&aacute; liều, thuốc &iacute;t g&acirc;y ra tai biến v&igrave; được dung nạp tốt ngay cả ở liều cao. Tuy nhi&ecirc;n, những phản ứng cấp xảy ra phụ thuộc v&agrave;o t&igrave;nh trạng qu&aacute; mẫn của từng c&aacute; thể. Nguy cơ tăng kali huyết khi d&ugrave;ng liều rất cao v&igrave; acid clavulanic được d&ugrave;ng dưới dạng muối kali.</p>

<p>Xử tr&iacute;: C&oacute; thể d&ugrave;ng phương ph&aacute;p thẩm ph&acirc;n m&aacute;u để loại thuốc ra khỏi tuần ho&agrave;n.</p>

<p><img alt="Dùng thuốc đúng liều lượng để hạn chế các tác dụng phụ có thể xảy ra" src="https://cdn.youmed.vn/tin-tuc/wp-content/uploads/2024/05/thuoc-klamentin-goi-4.jpg" style="height:468px; width:600px" /></p>

<p>D&ugrave;ng thuốc đ&uacute;ng liều lượng để hạn chế c&aacute;c t&aacute;c dụng phụ c&oacute; thể xảy ra</p>

<h2>Lưu &yacute; g&igrave; khi sử dụng?</h2>

<ul>
	<li>Đọc kỹ hướng dẫn đ&iacute;nh k&egrave;m trong bao b&igrave; của nh&agrave; sản xuất trước khi d&ugrave;ng Klamentin.</li>
	<li>Li&ecirc;n hệ b&aacute;c sĩ hay chuy&ecirc;n gia y tế kh&aacute;c mỗi khi cần để biết th&ecirc;m th&ocirc;ng tin cần thiết.</li>
	<li>Klamentin chỉ được sử dụng theo hướng dẫn v&agrave; k&ecirc; đơn của b&aacute;c sĩ.</li>
</ul>

<h2>C&aacute;ch bảo quản</h2>

<p>Bảo quản thuốc nơi kh&ocirc; r&aacute;o, nhiệt độ kh&ocirc;ng qu&aacute; 30&deg;C, tr&aacute;nh &aacute;nh s&aacute;ng.</p>

<h2>Thuốc Klamentin gi&aacute; bao nhi&ecirc;u?</h2>

<p>Th&ocirc;ng tin k&ecirc; khai tr&ecirc;n trang tin của Cục Quản l&yacute; dược về mức gi&aacute; của c&aacute;c h&agrave;m lượng lần lượt như sau:</p>

<ul>
	<li>Klamentin 250/31.25: 6.160 VND/g&oacute;i.</li>
	<li>Klamentin 500/62.5: 10.085 VND/g&oacute;i.</li>
</ul>

<p>Đ&acirc;y chỉ l&agrave; th&ocirc;ng tin tham khảo. Gi&aacute; b&aacute;n tr&ecirc;n thị trường c&oacute; thể c&oacute; thay đổi t&ugrave;y thuộc v&agrave;o đơn vị ph&acirc;n phối, nh&agrave; b&aacute;n lẻ v&agrave; c&aacute;c chương tr&igrave;nh khuyến m&atilde;i đi k&egrave;m.</p>

<p><strong>Thuốc Klamentin g&oacute;i</strong>, hay cốm pha hỗn dịch uống Klamentin, l&agrave; thuốc kh&aacute;ng sinh cần d&ugrave;ng theo hướng dẫn của nh&acirc;n vi&ecirc;n y tế. Sử dụng thuốc Klamentin đ&uacute;ng liều lượng, đủ thời gian v&agrave; đ&uacute;ng c&aacute;ch gi&uacute;p ph&aacute;t huy hiệu quả của thuốc v&agrave; đảm bảo an to&agrave;n trong qu&aacute; tr&igrave;nh sử dụng.</p>

<p><em>Tham khảo th&ecirc;m c&aacute;c thuốc chứa th&agrave;nh phần tương tự:&nbsp;</em>Cốm pha hỗn dịch uống Claminat,&nbsp;<a href="https://youmed.vn/tin-tuc/bot-pha-augmentin/">bột pha hỗn dịch uống Augmentin</a>, thuốc bột Augbidil.</p>
', '2025-07-19 01:38:08', '2025-07-19 14:00:43', 4);
INSERT INTO swp_db.news (id, title, image_preview, short_description, description, created_at, updated_at, created_by)
VALUES ( 9, 'Dạ dày: Cơ quan quan trọng của cơ thể mà bạn cần biết'
       , 'https://cdn.youmed.vn/tin-tuc/wp-content/uploads/2020/07/Gi%E1%BA%A3i-ph%E1%BA%ABu-d%E1%BA%A1-d%C3%A0y.png'
       , 'Dạ dày là một tạng rỗng trong đường tiêu hóa của con người và nhiều động vật khác, bao gồm một số động vật không xương sống. Trong hệ thống tiêu hóa, dạ dày tham gia vào giai đoạn thứ hai của quá trình tiêu hóa, sau khi thức ăn được nhai ở miệng. Quá trình tiêu hóa được thực hiện nhờ các enzym, acid và quá trình nhào trộn thức ăn. Sau đây bác sĩ Hoàng Thị Việt Trinh sẽ giúp bạn hiểu rõ hơn về cơ quan quan trọng này của cơ thể.'
       , '<h2>Giải phẫu</h2>

<p>Ở người v&agrave; nhiều động vật,&nbsp;<strong>dạ d&agrave;y</strong>&nbsp;nằm giữa thực quản v&agrave; ruột non. N&oacute; tiết ra c&aacute;c enzyme ti&ecirc;u h&oacute;a v&agrave; axit để hỗ trợ ti&ecirc;u h&oacute;a thức ăn. Cơ thắt m&ocirc;n vị kiểm so&aacute;t việc đưa thức ăn được ti&ecirc;u h&oacute;a một phần từ dạ d&agrave;y v&agrave;o t&aacute; tr&agrave;ng, để di chuyển qua c&aacute;c phần c&ograve;n lại của ruột.</p>

<p>Dạ d&agrave;y nằm ở phần tr&ecirc;n b&ecirc;n tr&aacute;i của khoang bụng. Đỉnh của dạ d&agrave;y nằm đ&egrave; l&ecirc;n cơ ho&agrave;nh. Nằm sau dạ d&agrave;y l&agrave; tuyến tụy. Một nếp gấp lớn của ph&uacute;c mạc tạng được treo xuống từ độ cong lớn của dạ d&agrave;y. Hai cơ v&ograve;ng giữ c&aacute;c chất được ở lại trong dạ d&agrave;y. B&ecirc;n cạnh đ&oacute;, c&oacute; c&aacute;c cơ thắt thực quản dưới tại ng&atilde; ba của thực quản v&agrave; dạ d&agrave;y, v&agrave; cơ thắt m&ocirc;n vị ở ng&atilde; ba của dạ d&agrave;y với t&aacute; tr&agrave;ng.</p>

<p>Dạ d&agrave;y được bao quanh bởi c&aacute;c đ&aacute;m rối thần kinh giao cảm v&agrave; đối giao cảm. Ch&uacute;ng điều chỉnh cả hoạt động b&agrave;i tiết của dạ d&agrave;y v&agrave; chuyển động c&aacute;c cơ của dạ d&agrave;y.</p>

<p>Bởi v&igrave; dạ d&agrave;y l&agrave; một cơ quan c&oacute; thể d&atilde;n rộng, n&oacute; thường d&atilde;n rộng để chứa khoảng một l&iacute;t thức ăn. Dạ d&agrave;y của một đứa trẻ sơ sinh sẽ chỉ c&oacute; thể giữ lại khoảng 30 ml. Thể t&iacute;ch dạ d&agrave;y tối đa ở người lớn c&oacute; thể &nbsp;từ 2 đến 4 l&iacute;t.</p>

<p>Dạ d&agrave;y c&oacute; khả năng mở rộng hoặc co lại t&ugrave;y thuộc v&agrave;o lượng thức ăn c&oacute; trong đ&oacute;. C&aacute;c bức tường b&ecirc;n trong th&agrave;nh dạ d&agrave;y tạo th&agrave;nh nhiều nếp gấp. Lớp m&agrave;ng ni&ecirc;m mạc d&agrave;y của c&aacute;c bức tường chứa c&aacute;c tuyến dạ d&agrave;y nhỏ; những chất n&agrave;y tiết ra hỗn hợp enzyme v&agrave; axit hydrochloric gi&uacute;p ti&ecirc;u h&oacute;a một phần protein v&agrave; chất b&eacute;o.</p>

<p><img alt="Giải phẫu dạ dày" src="https://cdn.youmed.vn/tin-tuc/wp-content/uploads/2020/07/Gi%E1%BA%A3i-ph%E1%BA%ABu-d%E1%BA%A1-d%C3%A0y.png" style="height:425px; width:600px" /></p>

<p>Giải phẫu dạ d&agrave;y</p>

<h2>Cung cấp m&aacute;u</h2>

<p>Bờ cong nhỏ v&agrave; bờ cong lớn của&nbsp;<strong>dạ d&agrave;y</strong>&nbsp;được cung cấp m&aacute;u bởi động mạch thượng vị phải ph&iacute;a dưới v&agrave; động mạch thượng vị tr&aacute;i ph&iacute;a tr&ecirc;n. Đ&aacute;y của dạ d&agrave;y- phần tr&ecirc;n của độ cong lớn hơn, được cung cấp m&aacute;u bởi c&aacute;c động mạch thượng vị ngắn, ph&aacute;t sinh từ động mạch l&aacute;ch.</p>

<h2>Chức năng</h2>

<h3>Ti&ecirc;u h&oacute;a</h3>

<p>Trong hệ thống ti&ecirc;u h&oacute;a của con người, thức ăn đi v&agrave;o dạ d&agrave;y qua thực quản th&ocirc;ng qua cơ thắt thực quản dưới. Dạ d&agrave;y giải ph&oacute;ng c&aacute;c protease (enzyme ti&ecirc;u h&oacute;a protein như pepsin) v&agrave; axit hydrochloric, gi&uacute;p ti&ecirc;u h&oacute;a thức ăn v&agrave; cung cấp pH axit cho c&aacute;c protease hoạt động. Thức ăn bị khuấy động bởi dạ d&agrave;y th&ocirc;ng qua c&aacute;c cơn co thắt- được gọi l&agrave; nhu động. Enzym từ từ đi qua cơ thắt m&ocirc;n vị v&agrave; v&agrave;o t&aacute; tr&agrave;ng của&nbsp;<a href="https://youmed.vn/tin-tuc/ung-thu-ruot-non-benh-it-gap-nhung-khong-nen-xem-thuong/" target="_blank">ruột non</a>, nơi bắt đầu hấp thu c&aacute;c chất dinh dưỡng.</p>

<p>Dịch dạ d&agrave;y cũng chứa pepsinogen. Axit clohydric k&iacute;ch hoạt dạng enzyme kh&ocirc;ng hoạt động n&agrave;y th&agrave;nh dạng hoạt động- pepsin. Pepsin ph&aacute; vỡ c&aacute;c li&ecirc;n kết protein th&agrave;nh polypeptide.</p>

<h3>Hấp thụ</h3>

<p>Mặc d&ugrave; sự hấp thụ trong hệ thống ti&ecirc;u h&oacute;a của con người chủ yếu l&agrave; chức năng của ruột non, tuy nhi&ecirc;n một số sự hấp thụ của một số ph&acirc;n tử nhỏ vẫn xảy ra trong dạ d&agrave;y th&ocirc;ng qua lớp ni&ecirc;m mạc của n&oacute;.</p>

<p>Chất sắt v&agrave; c&aacute;c chất tan trong chất b&eacute;o cao như rượu v&agrave; một số loại thuốc được hấp thụ trực tiếp. Sự b&agrave;i tiết v&agrave; chuyển động của dạ d&agrave;y được kiểm so&aacute;t bởi d&acirc;y thần kinh phế vị v&agrave; hệ thần kinh giao cảm. Căng thẳng cảm x&uacute;c c&oacute; thể thay đổi chức năng dạ d&agrave;y b&igrave;nh thường.</p>

<p>&nbsp;C&aacute;c chất được hấp thu ở dạ d&agrave;y bao gồm:</p>

<ul>
	<li>Nước, nếu cơ thể bị mất nước.</li>
	<li>Thuốc, chẳng hạn như&nbsp;<a href="https://youmed.vn/tin-tuc/thuoc-aspirin/">aspirin</a>.</li>
	<li><a href="https://youmed.vn/tin-tuc/axit-beo-tot-chat-dinh-duong-quan-trong-doi-voi-tre/" target="_blank">Axit amin</a>.</li>
	<li>10- 20% ethanol (v&iacute; dụ từ đồ uống c&oacute; cồn).</li>
	<li>Caffeine.</li>
	<li>Một lượng nhỏ vitamin tan trong nước (hầu hết được hấp thụ ở ruột non).</li>
</ul>

<p>C&aacute;c tế b&agrave;o th&agrave;nh của dạ d&agrave;y chịu tr&aacute;ch nhiệm sản xuất yếu tố nội tại, cần thiết cho sự hấp thụ vitamin B12.&nbsp;<a href="https://youmed.vn/tin-tuc/8-cong-dung-cua-vitamin-b12-doi-voi-suc-khoe/" target="_blank">Vitamin B12</a>&nbsp;được sử dụng trong chuyển h&oacute;a tế b&agrave;o v&agrave; cần thiết cho việc sản xuất c&aacute;c tế b&agrave;o hồng cầu, v&agrave; hoạt động của hệ thống thần kinh.</p>

<h3>Kiểm so&aacute;t b&agrave;i tiết v&agrave; vận động</h3>

<p>C&aacute;c cơ dạ d&agrave;y hiếm khi kh&ocirc;ng hoạt động. Khi kh&ocirc;ng c&oacute; thức ăn, ch&uacute;ng thư gi&atilde;n ngắn ngủi, sau đ&oacute; bắt đầu hoạt động. C&aacute;c cơn co thắt nh&agrave;o trộn thức ăn tạo th&agrave;nh hỗn hợp gọi l&agrave; dưỡng trấp.&nbsp; C&aacute;c cơn co thắt nhu động vẫn tồn tại sau khi dạ d&agrave;y trống rỗng v&agrave; tăng dần theo thời gian c&oacute; thể trở n&ecirc;n đau đớn khi c&aacute;c cơn đ&oacute;i xảy ra.</p>

<p>Sự chuyển động thức ăn v&agrave; b&agrave;i tiết c&aacute;c h&oacute;a chất trong dạ d&agrave;y được kiểm so&aacute;t bởi cả hệ thống thần kinh tự trị v&agrave; bởi c&aacute;c hormone ti&ecirc;u h&oacute;a kh&aacute;c nhau của hệ thống ti&ecirc;u h&oacute;a:</p>

<ul>
	<li>
	<p>Gastrin</p>
	</li>
</ul>

<p>Hormon gastrin g&acirc;y ra sự gia tăng b&agrave;i tiết HCl từ c&aacute;c tế b&agrave;o th&agrave;nh v&agrave; pepsinogen từ c&aacute;c tế b&agrave;o ch&iacute;nh trong dạ d&agrave;y. N&oacute; cũng g&acirc;y tăng nhu động trong dạ d&agrave;y. Gastrin được giải ph&oacute;ng bởi c&aacute;c tế b&agrave;o G trong dạ d&agrave;y để đ&aacute;p ứng với c&aacute;c sản phẩm ti&ecirc;u h&oacute;a (đặc biệt l&agrave; một lượng lớn protein được ti&ecirc;u h&oacute;a kh&ocirc;ng đầy đủ). N&oacute; bị ức chế bởi độ pH thường dưới 4 (axit cao), cũng như hormone somatostatin.</p>

<ul>
	<li>
	<p>Cholecystokinin</p>
	</li>
</ul>

<p>Cholecystokinin (CCK) c&oacute; t&aacute;c dụng đối với t&uacute;i mật, g&acirc;y co thắt t&uacute;i mật, nhưng n&oacute; cũng l&agrave;m giảm l&agrave;m trống dạ d&agrave;y v&agrave; tăng giải ph&oacute;ng dịch tụy, c&oacute; t&iacute;nh kiềm. CCK được tổng hợp bởi c&aacute;c tế b&agrave;o I trong biểu m&ocirc; ni&ecirc;m mạc của ruột non.</p>

<ul>
	<li>
	<p>Secretin</p>
	</li>
</ul>

<p>Secretin c&oacute; t&aacute;c dụng đối với tuyến tụy, cũng l&agrave;m giảm b&agrave;i tiết axit trong&nbsp;<strong>dạ d&agrave;y</strong>.&nbsp; Secretin được tổng hợp bởi c&aacute;c tế b&agrave;o S nằm trong ni&ecirc;m mạc t&aacute; tr&agrave;ng cũng như ở ni&ecirc;m mạc hỗng tr&agrave;ng với số lượng nhỏ hơn.</p>

<p>Kh&aacute;c với gastrin, tất cả c&aacute;c hormone n&agrave;y đều c&oacute; t&aacute;c dụng ngăn cản hoạt động của dạ d&agrave;y. Điều n&agrave;y l&agrave; để đ&aacute;p ứng với c&aacute;c sản phẩm trong gan v&agrave; t&uacute;i mật chưa được hấp thụ. Dạ d&agrave;y chỉ cần đẩy thức ăn v&agrave;o ruột non khi ruột kh&ocirc;ng trống. Trong khi ruột đầy v&agrave; vẫn ti&ecirc;u h&oacute;a thức ăn, dạ d&agrave;y đ&oacute;ng vai tr&ograve; l&agrave; nơi dự trữ thức ăn.</p>

<h2>Bệnh l&yacute; ở dạ d&agrave;y</h2>

<ul>
	<li>
	<p>Tr&agrave;o ngược dạ d&agrave;y thực quản</p>
	</li>
</ul>

<p>C&aacute;c chất chứa của dạ d&agrave;y, bao gồm axit, c&oacute; thể di chuyển ngược l&ecirc;n thực quản. C&oacute; thể kh&ocirc;ng g&acirc;y triệu chứng, hoặc tr&agrave;o ngược c&oacute; thể g&acirc;y ợ n&oacute;ng hoặc ợ chua.</p>

<ul>
	<li>
	<p>Bệnh tr&agrave;o ngược dạ d&agrave;y thực quản (GERD)</p>
	</li>
</ul>

<p>Khi c&aacute;c triệu chứng tr&agrave;o ngược trở n&ecirc;n kh&oacute; chịu hoặc xảy ra thường xuy&ecirc;n, ch&uacute;ng gọi l&agrave;&nbsp;<a href="https://youmed.vn/tin-tuc/viem-da-day-trao-nguoc-thuc-quan-nhung-dieu-ban-nen-biet/">GERD</a>. GERD c&oacute; thể g&acirc;y ra c&aacute;c vấn đề nghi&ecirc;m trọng của thực quản.</p>

<p><img alt="trào ngược dạ dày thực quản (GERD)" src="https://cdn.youmed.vn/tin-tuc/wp-content/uploads/2020/07/H-17.jpg" style="height:478px; width:600px" /></p>

<p>Bệnh tr&agrave;o ngược dạ d&agrave;y thực quản (GERD)</p>

<ul>
	<li>
	<p>Chứng kh&oacute; ti&ecirc;u</p>
	</li>
</ul>

<p>Chứng kh&oacute; ti&ecirc;u c&oacute; thể được g&acirc;y ra bởi hầu hết c&aacute;c t&igrave;nh trạng l&agrave;nh t&iacute;nh hoặc nghi&ecirc;m trọng ảnh hưởng đến dạ d&agrave;y.</p>

<ul>
	<li>
	<p>Lo&eacute;t dạ d&agrave;y</p>
	</li>
</ul>

<p>X&oacute;i m&ograve;n ni&ecirc;m mạc dạ d&agrave;y, thường g&acirc;y đau v&agrave; / hoặc chảy m&aacute;u. Lo&eacute;t dạ d&agrave;y thường do NSAIDs hoặc nhiễm &nbsp;vi r&uacute;t H. pylori.</p>

<ul>
	<li>
	<p>Bệnh lo&eacute;t dạ d&agrave;y t&aacute; tr&agrave;ng</p>
	</li>
</ul>

<p>Khi vị tr&iacute; lo&eacute;t ở dạ d&agrave;y hoặc t&aacute; tr&agrave;ng (phần đầu ti&ecirc;n của ruột non) gọi l&agrave; bệnh lo&eacute;t dạ d&agrave;y t&aacute; tr&agrave;ng.</p>

<p><img alt="loét dạ dày tá tràng" src="https://cdn.youmed.vn/tin-tuc/wp-content/uploads/2020/07/H-18.jpg" style="height:399px; width:600px" /></p>

<p>Bệnh lo&eacute;t dạ d&agrave;y t&aacute; tr&agrave;ng</p>

<ul>
	<li>
	<p>Vi&ecirc;m dạ d&agrave;y</p>
	</li>
</ul>

<p>Vi&ecirc;m dạ d&agrave;y thường g&acirc;y buồn n&ocirc;n v&agrave; / hoặc đau. Vi&ecirc;m dạ d&agrave;y c&oacute; thể do rượu, một số loại thuốc, nhiễm H. pylori hoặc c&aacute;c yếu tố kh&aacute;c.</p>

<ul>
	<li>
	<p>Ung thư dạ d&agrave;y</p>
	</li>
	<li>
	<p>Hội chứng Zollinger-Ellison&nbsp;</p>
	</li>
</ul>

<p>Một hoặc nhiều khối u tiết ra hormone dẫn đến tăng sản xuất axit. GERD nặng v&agrave; bệnh lo&eacute;t dạ d&agrave;y c&oacute; thể l&agrave; do rối loạn hiếm gặp n&agrave;y.</p>

<ul>
	<li>
	<p>Gi&atilde;n tĩnh mạch dạ d&agrave;y</p>
	</li>
</ul>

<p>Ở những người bị bệnh gan nặng, tĩnh mạch trong dạ d&agrave;y c&oacute; thể ph&igrave;nh ra dưới &aacute;p lực tăng. Được gọi l&agrave; gi&atilde;n tĩnh mạch, những tĩnh mạch n&agrave;y c&oacute; nguy cơ chảy m&aacute;u cao, mặc d&ugrave; &iacute;t hơn so với gi&atilde;n tĩnh mạch thực quản.</p>

<p><img alt="Phân độ dãn tĩnh mạch dạ dày" src="https://cdn.youmed.vn/tin-tuc/wp-content/uploads/2020/07/Ph%C3%A2n-%C4%91%E1%BB%99-d%C3%A3n-t%C4%A9nh-m%E1%BA%A1ch-d%E1%BA%A1-d%C3%A0y.jpg" style="height:450px; width:600px" /></p>

<p>Ph&acirc;n độ d&atilde;n tĩnh mạch dạ d&agrave;y</p>

<ul>
	<li>
	<p>Xuất huyết dạ d&agrave;y</p>
	</li>
</ul>

<p>Vi&ecirc;m dạ d&agrave;y, lo&eacute;t hoặc ung thư dạ d&agrave;y c&oacute; thể chảy m&aacute;u. Nh&igrave;n thấy m&aacute;u hoặc chất đen trong chất n&ocirc;n hoặc ph&acirc;n thường l&agrave; một cấp cứu y khoa.</p>

<ul>
	<li>
	<p>Liệt dạ d&agrave;y (tr&igrave; ho&atilde;n việc l&agrave;m rỗng dạ d&agrave;y)</p>
	</li>
</ul>

<p>Tổn thương thần kinh do bệnh tiểu đường hoặc c&aacute;c t&igrave;nh trạng kh&aacute;c c&oacute; thể l&agrave;m suy yếu c&aacute;c cơn co thắt c&aacute;c cơ của dạ d&agrave;y. Buồn n&ocirc;n v&agrave; n&ocirc;n l&agrave; những triệu chứng thường gặp.</p>

<h2>X&eacute;t nghiệm bệnh l&yacute; dạ d&agrave;y</h2>

<ul>
	<li>
	<p>Nội soi dạ d&agrave;y thực quản</p>
	</li>
</ul>

<p>&nbsp;Một ống soi c&oacute; camera ở đầu của n&oacute; được đưa v&agrave;o qua miệng. Nội soi cho ph&eacute;p kiểm tra thực quản, dạ d&agrave;y v&agrave; t&aacute; tr&agrave;ng (phần đầu ti&ecirc;n của ruột non).</p>

<ul>
	<li>
	<p>Chụp cắt lớp vi t&iacute;nh (CT scan)</p>
	</li>
</ul>

<p>M&aacute;y chụp CT sử dụng tia X để tạo h&igrave;nh ảnh của dạ d&agrave;y v&agrave; bụng.</p>

<ul>
	<li>
	<p>Chụp cộng hưởng từ</p>
	</li>
</ul>

<p>Sử dụng từ trường, m&aacute;y qu&eacute;t tạo ra h&igrave;nh ảnh c&oacute; độ ph&acirc;n giải cao của dạ d&agrave;y v&agrave; bụng.</p>

<ul>
	<li>
	<p>Kiểm tra pH</p>
	</li>
</ul>

<p>Sử dụng một ống qua mũi v&agrave;o thực quản, nồng độ axit trong thực quản c&oacute; thể được theo d&otilde;i. Điều n&agrave;y c&oacute; thể gi&uacute;p chẩn đo&aacute;n hoặc thay đổi điều trị cho GERD.</p>

<ul>
	<li>
	<p>Sinh thiết dạ d&agrave;y</p>
	</li>
</ul>

<p>Trong khi nội soi, b&aacute;c sĩ c&oacute; thể lấy một mảnh m&ocirc;<strong>&nbsp;dạ d&agrave;y</strong>&nbsp;nhỏ để x&eacute;t nghiệm. Điều n&agrave;y c&oacute; thể chẩn đo&aacute;n nhiễm H. pylori, ung thư hoặc c&aacute;c vấn đề kh&aacute;c.</p>

<ul>
	<li>
	<p>X&eacute;t nghiệm H. pylori</p>
	</li>
</ul>

<p>Trong khi hầu hết những người bị nhiễm H. pylori kh&ocirc;ng bị lo&eacute;t, x&eacute;t nghiệm m&aacute;u hoặc ph&acirc;n đơn giản c&oacute; thể được thực hiện để kiểm tra nhiễm tr&ugrave;ng ở những người bị lo&eacute;t hoặc để x&aacute;c minh rằng nhiễm tr&ugrave;ng đ&atilde; được x&oacute;a sạch sau khi điều trị.</p>

<h2>Điều trị</h2>

<ul>
	<li>Thuốc kh&aacute;ng histamine (H2)</li>
</ul>

<p>Histamine l&agrave;m tăng tiết axit dạ d&agrave;y. Kh&aacute;ng histamine c&oacute; thể l&agrave;m giảm sản xuất axit v&agrave; c&aacute;c triệu chứng GERD.</p>

<ul>
	<li>Thuốc ức chế bơm proton</li>
</ul>

<p>Những loại thuốc n&agrave;y ức chế trực tiếp c&aacute;c bơm axit trong&nbsp;<strong>dạ d&agrave;y</strong>. Ch&uacute;ng phải được d&ugrave;ng h&agrave;ng ng&agrave;y để c&oacute; hiệu quả.</p>

<ul>
	<li>Thuốc kh&aacute;ng axit</li>
</ul>

<p>Những loại thuốc n&agrave;y c&oacute; thể gi&uacute;p chống lại t&aacute;c dụng của axit nhưng kh&ocirc;ng ti&ecirc;u diệt vi khuẩn hoặc ngừng sản xuất axit.</p>

<ul>
	<li>Nội soi dạ d&agrave;y thực quản</li>
</ul>

<p>Trong khi nội soi, c&aacute;c c&ocirc;ng cụ được sử dụng để cầm m&aacute;u, nếu c&oacute; chảy m&aacute;u</p>

<ul>
	<li>Tăng vận động của dạ d&agrave;y</li>
</ul>

<p>Thuốc c&oacute; thể l&agrave;m tăng sự co b&oacute;p của dạ d&agrave;y, cải thiện c&aacute;c triệu chứng của bệnh dạ d&agrave;y.</p>

<ul>
	<li>Phẫu thuật dạ d&agrave;y</li>
</ul>

<p>C&aacute;c trường hợp chảy m&aacute;u dạ d&agrave;y nghi&ecirc;m trọng, lo&eacute;t vỡ hoặc ung thư đ&ograve;i hỏi phải phẫu thuật để được chữa khỏi.</p>

<ul>
	<li>Kh&aacute;ng sinh</li>
</ul>

<p>Nhiễm&nbsp;<a href="https://youmed.vn/tin-tuc/helicobacter-pylori-ke-thu-tham-lang-cua-suc-khoe/">H. pylori</a>&nbsp;c&oacute; thể được chữa khỏi bằng kh&aacute;ng sinh, được d&ugrave;ng c&ugrave;ng với c&aacute;c loại thuốc kh&aacute;c để chữa l&agrave;nh dạ d&agrave;y.</p>

<p>T&oacute;m lại,&nbsp;<strong>dạ d&agrave;y</strong>&nbsp;l&agrave; cơ quan quan trọng của đường ti&ecirc;u h&oacute;a, l&agrave; nơi diễn ra qu&aacute; tr&igrave;nh ti&ecirc;u h&oacute;a, vận chuyển c&aacute;c chất v&agrave; hấp thụ c&aacute;c chất trong cơ thể.</p>
', '2025-07-19 01:38:08', '2025-07-19 14:06:24', 4);
INSERT INTO swp_db.news (id, title, image_preview, short_description, description, created_at, updated_at, created_by)
VALUES ( 10, 'Suýt tử vong vì lầm tưởng nhồi máu cơ tim là đau dạ dày'
       , 'https://hongngochospital.vn/_default_upload_bucket/DSC00247.jpg'
       , 'Chia sẻ sau những giây phút căng não giành giật sự sống cho ông Sơn (66 tuổi - Hà Nội), ThS. BS Nguyễn Văn Hải - Trưởng khoa Tim mạch - Tim mạch can thiệp BVĐK G3 cho biết “Nếu điều trị muộn thêm vài giờ nữa, khả năng cứu sống bệnh nhân gần như bằng không do vùng cơ tim bị hoại tử lan rộng, không có khả năng phục hồi”.'
       , '<p>Khoảnh khắc &ocirc;ng Sơn trở về từ &ldquo;cửa tử&rdquo;, người nh&agrave; x&uacute;c động kể lại, tối h&ocirc;m trước sau bữa ăn &ocirc;ng Sơn cảm thấy đau v&ugrave;ng thượng vị (tr&ecirc;n rốn v&agrave; dưới ngực) k&egrave;m theo buồn n&ocirc;n v&agrave; mệt mỏi. Nghĩ đ&acirc;y l&agrave; triệu chứng bệnh dạ d&agrave;y t&aacute;i ph&aacute;t n&ecirc;n &ocirc;ng chỉ nghỉ ngơi m&agrave; kh&ocirc;ng đi kh&aacute;m. Nhưng cơn đau kh&ocirc;ng hề thuy&ecirc;n giảm m&agrave; tiếp tục h&agrave;nh hạ &ocirc;ng trong 24 giờ tiếp theo với tần suất dồn dập hơn, cơn đau k&eacute;o d&agrave;i từ 10 - 15 ph&uacute;t rồi lan dần l&ecirc;n ngực v&agrave; hai vai khiến &ocirc;ng kh&oacute; thở v&agrave; cho&aacute;ng v&aacute;ng.&nbsp;</p>

<p>Đ&ecirc;m muộn, &ocirc;ng Sơn mới v&agrave;o nhập viện cấp cứu tại BVĐK Hồng Ngọc. Qua khai th&aacute;c nhanh &ocirc;ng Sơn c&oacute; tiền sử bệnh dạ d&agrave;y nhiều năm, k&egrave;m đ&aacute;i th&aacute;o đường v&agrave; rối loạn chuyển h&oacute;a lipid m&aacute;u. Với kết quả điện tim bất thường c&ugrave;ng chỉ số x&eacute;t nghiệm men tim l&ecirc;n tới 2700 ng/L (chỉ số b&igrave;nh thường 14 ng/L), cao gấp h&agrave;ng trăm lần chỉ số b&igrave;nh thường, &ocirc;ng Sơn được chẩn đo&aacute;n nhồi m&aacute;u cơ tim cấp ST ch&ecirc;nh l&ecirc;n.&nbsp;</p>

<p>BSNT.BSCKII L&ecirc; Đức Hiệp - Khoa Tim mạch - Tim mạch can thiệp BVĐK Hồng Ngọc, người trực tiếp cấp cứu cho &ocirc;ng Sơn chia sẻ th&ecirc;m, da v&agrave; ni&ecirc;m mạc bệnh nh&acirc;n t&aacute;i nhợt, tim đập nhanh, huyết &aacute;p c&oacute; xu hướng giảm dần c&ugrave;ng với h&igrave;nh ảnh điện t&acirc;m đồ ghi nhận thiếu m&aacute;u nu&ocirc;i tim diện rộng khiến tim kh&ocirc;ng nhận đủ oxy để hoạt động b&igrave;nh thường dẫn tới một phần cơ tim của &ocirc;ng Sơn đ&atilde; bị hoại tử. &Ocirc;ng Sơn đứng trước lằn ranh sinh tử v&igrave; nguy cơ sốc tim, v&agrave; đột tử l&agrave; rất cao.</p>

<p>&ldquo;Mặc d&ugrave; khả năng cứu sống bệnh nh&acirc;n rất mong manh nhưng ch&uacute;ng t&ocirc;i quyết t&acirc;m bằng mọi c&aacute;ch giảm thiểu tối đa di chứng v&agrave; kh&ocirc;i phục sự sống cơ tim cho &ocirc;ng Sơn&rdquo;. B&aacute;c sĩ Hiệp chia sẻ.</p>

<p><img src="https://hongngochospital.vn/_default_upload_bucket/DSC00247.jpg" style="height:4672px; width:100%" /></p>

<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<em>Bệnh nh&acirc;n Sơn trong ph&ograve;ng can thiệp tim mạch</em></p>

<h2><strong>&ldquo;Chạy đua với thời gian&rdquo; gi&agrave;nh giật sự sống cho bệnh nh&acirc;n</strong></h2>

<p>Ngay lập tức, &ocirc;ng Sơn được chuyển l&ecirc;n ph&ograve;ng can thiệp tim mạch. Kết quả chụp mạch v&agrave;nh cho thấy lượng huyết khối lớn g&acirc;y tắc ho&agrave;n to&agrave;n tại đoạn I của động mạch v&agrave;nh phải. Đ&acirc;y l&agrave; một trong ba động mạch quan trọng cung cấp m&aacute;u nu&ocirc;i tim cho bệnh nh&acirc;n.</p>

<p><img src="https://hongngochospital.vn/_default_upload_bucket/1_72.png" style="height:550px; width:100%" /></p>

<p><em>&nbsp;Huyết khối g&acirc;y tắc ho&agrave;n to&agrave;n động mạch v&agrave;nh phải</em></p>

<p>Với chiến lược nhanh ch&oacute;ng v&agrave; thao t&aacute;c cẩn trọng &ecirc; k&iacute;p đ&atilde; h&uacute;t được rất nhiều cục m&aacute;u đ&ocirc;ng ra khỏi mạch v&agrave;nh, mở đường cho việc đặt th&agrave;nh c&ocirc;ng 01 stent đường k&iacute;nh 4.0mm v&agrave; d&agrave;i 28mm gi&uacute;p khơi th&ocirc;ng d&ograve;ng m&aacute;u nu&ocirc;i tim, ngăn chặn phần cơ tim bị hoại tử lan rộng.</p>

<p>B&aacute;c sĩ Hải cho biết đối với trường hợp nhồi m&aacute;u cơ tim như &ocirc;ng Sơn, c&aacute;c nh&aacute;nh động mạch v&agrave;nh thường c&oacute; xu hướng co nhỏ lại. V&igrave; vậy, h&igrave;nh ảnh chụp mạch v&agrave;nh c&oacute; thể cho thấy đường k&iacute;nh l&ograve;ng mạch nhỏ hơn k&iacute;ch thước thực tế. Nếu đặt stent dựa tr&ecirc;n sự hướng dẫn của những h&igrave;nh ảnh n&agrave;y sẽ kh&ocirc;ng đảm bảo ch&iacute;nh x&aacute;c v&igrave; đường k&iacute;nh của stent c&oacute; thể qu&aacute; nhỏ so với k&iacute;ch thước thực tế của l&ograve;ng mạch. Điều n&agrave;y sẽ l&agrave;m tăng nguy cơ h&igrave;nh th&agrave;nh c&aacute;c cục m&aacute;u đ&ocirc;ng v&agrave; t&aacute;i hẹp stent.</p>

<p>Dưới sự hỗ trợ của hệ thống Si&ecirc;u &acirc;m trong l&ograve;ng mạch c&aacute;c b&aacute;c sĩ đo đạc ch&iacute;nh x&aacute;c đường k&iacute;nh thực tế của l&ograve;ng mạch v&agrave; đ&aacute;nh gi&aacute; đặc điểm của tổn thương. Từ đ&oacute;, chọn được stent ph&ugrave; hợp cũng như kiểm qu&aacute; lại tr&igrave;nh đặt stent đ&atilde; đạt kết quả tối ưu chưa.</p>

<p><img src="https://hongngochospital.vn/_default_upload_bucket/2_75.png" style="height:550px; width:100%" /></p>

<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;T<em>h&agrave;nh c&ocirc;ng đặt 01 stent k&iacute;ch thước 4.0 x 26 mm</em></p>

<p>Chỉ trong v&ograve;ng 60 ph&uacute;t kể từ khi &ecirc; k&iacute;p b&aacute;c sĩ BVĐK Hồng Ngọc tiếp nhận cấp cứu, thực hiện c&aacute;c x&eacute;t nghiệm cận l&acirc;m s&agrave;ng v&agrave; tiến h&agrave;nh can thiệp th&agrave;nh c&ocirc;ng, tr&aacute;i tim &ocirc;ng Sơn đ&atilde; được &ldquo;hồi sinh&rdquo; kỳ diệu. Ngay sau thủ thuật, &ocirc;ng Sơn hết hẳn đau bụng, kh&ocirc;ng c&ograve;n kh&oacute; thở, nhịp tim v&agrave; huyết &aacute;p ổn định. &Ocirc;ng đi lại, vận động nhẹ nh&agrave;ng sau 01 ng&agrave;y.</p>

<p>Qua trường hợp của &ocirc;ng Sơn, b&aacute;c sĩ Hải cũng đặc biệt nhấn mạnh, người bệnh cần cảnh gi&aacute;c c&aacute;c triệu chứng nhồi m&aacute;u cơ tim v&igrave; nhiều trường hợp c&oacute; triệu chứng kh&ocirc;ng điển h&igrave;nh dễ g&acirc;y nhầm lẫn với vấn đề ti&ecirc;u h&oacute;a như: đau v&ugrave;ng thượng vị k&egrave;m buồn n&ocirc;n, ch&oacute;ng mặt, cho&aacute;ng v&aacute;ng,... dẫn đến chủ quan v&agrave; chậm trễ trong việc điều trị, g&acirc;y ra những hậu quả nghi&ecirc;m trọng như tổn thương tim vĩnh viễn hoặc thậm ch&iacute; tử vong.</p>
', '2025-07-19 01:38:08', '2025-07-19 14:06:24', 4);
INSERT INTO swp_db.news (id, title, image_preview, short_description, description, created_at, updated_at, created_by)
VALUES ( 11, 'Hội thảo: “Giải pháp phòng ngừa Zona ở người mắc bệnh mạn tính, từ khuyến cáo đến bằng chứng lâm sàng”'
       , 'https://hongngochospital.vn/_default_upload_bucket/1%20(1)_1.png'
       , 'Ngày 3/7/2025, BVĐK G3 phối hợp với Công ty Dược phẩm GSK Việt Nam tổ chức hội thảo khoa học dưới sự điều phối của Ban Giám đốc BVĐK G3, cùng phần trình bày chuyên môn từ PGS.TS.BS Phạm Quang Thái - Viện Vệ sinh Dịch tễ Trung ương và sự tham dự của gần 100 bác sĩ đến từ các chuyên khoa Nội, Tiêm chủng, Tim mạch, Dược,… BVĐK G3'
       , '<p><img src="https://hongngochospital.vn/_default_upload_bucket/1%20(1)_1.png" style="height:1365px; width:100%" /></p>

<p><em>Hội thảo thu h&uacute;t sự tham dự v&agrave; thảo luận s&ocirc;i nổi của hơn 100 b&aacute;c sĩ&nbsp;chuy&ecirc;n khoa Nội, Ti&ecirc;m chủng, Tim mạch, Dược,&hellip; BVĐK Hồng Ngọc.</em></p>

<p>Theo PGS.TS.BS Phạm Quang Th&aacute;i: &ldquo;Hơn 90% người &gt; 50 tuổi mang virus g&acirc;y Zona trong người, ch&iacute;nh l&agrave; Varicella Zoster Virus (VZV) - t&aacute;c nh&acirc;n g&acirc;y bệnh thủy đậu. Đa phần bệnh nh&acirc;n sau khi khỏi ho&agrave;n to&agrave;n thủy đậu, VZV kh&ocirc;ng biến mất, ch&uacute;ng tồn tại, nằm im trong hạch thần kinh v&agrave; b&ugrave;ng ph&aacute;t, tấn c&ocirc;ng ở da, d&acirc;y thần kinh khi hệ miễn dịch cơ thể suy giảm do tuổi t&aacute;c hoặc bệnh l&yacute; nền (đ&aacute;i th&aacute;o đường, tim mạch, thận, hen, HIV, cơ xương khớp mạn t&iacute;nh,...). Khoảng 60% bệnh nh&acirc;n Zona đau nặng v&agrave; khoảng 20% đau ngo&agrave;i sức chịu đựng của cơ thể suốt 3-6 th&aacute;ng, ảnh hưởng trực tiếp đến mọi kh&iacute;a cạnh của cuộc sống. V&igrave; vậy ti&ecirc;m vắc-xin ngừa Zona l&agrave; biện ph&aacute;p đơn giản được Bộ Y Tế khuyến c&aacute;o với hiệu quả bảo vệ l&ecirc;n đến 97,2%, duy tr&igrave; tới 11 năm, d&ugrave;ng được cả với người cao tuổi đang suy giảm miễn dịch.&quot;</p>

<p><img src="https://hongngochospital.vn/_default_upload_bucket/1%20(5).png" style="height:1365px; width:100%" /></p>

<p><em>PGS.TS.BS Phạm Quang Th&aacute;i - Viện Vệ sinh Dịch tễ Trung ương tham gia b&aacute;o c&aacute;o tại Hội thảo.</em></p>

<p>B&ecirc;n cạnh đ&oacute;, đại diện BVĐK Hồng Ngọc, ThS.BSCKII B&ugrave;i Thanh Tiến (PGĐ BVĐK Hồng Ngọc Ph&uacute;c Trường Minh) chia sẻ th&ecirc;m: &ldquo;BVĐK Hồng Ngọc cũng đ&atilde; tiếp nhận v&agrave; điều trị rất nhiều bệnh nh&acirc;n tr&ecirc;n 50 tuổi bị Zona thần kinh với mức độ đau tương đương đau mạn t&iacute;nh do ung thư, kh&ocirc;ng &iacute;t trường hợp phải điều trị phục hồi chức năng sau biến chứng thần kinh hậu Zona. Từ thực tiễn l&acirc;m s&agrave;ng đ&oacute;, ch&uacute;ng t&ocirc;i nhận thức r&otilde; tầm quan trọng của ph&ograve;ng bệnh chủ động v&agrave; sẵn s&agrave;ng triển khai c&aacute;c biện ph&aacute;p tăng cường tiếp cận ti&ecirc;m chủng vắc-xin ph&ograve;ng Zona, nhằm bảo vệ sức khỏe người bệnh c&oacute; bệnh l&yacute; nền, người cao tuổi v&agrave; g&oacute;p phần giảm g&aacute;nh nặng cho cộng đồng.&rdquo;</p>

<p><img src="https://hongngochospital.vn/_default_upload_bucket/1%20(7).png" style="height:1365px; width:100%" /></p>

<p><em>ThS.BSCKII B&ugrave;i Thanh Tiến (PGĐ BVĐK Hồng Ngọc Ph&uacute;c Trường Minh) chia sẻ tại Hội thảo.</em></p>

<p>Kh&eacute;p lại hội thảo, c&aacute;c b&aacute;c sĩ một lần nữa nhấn mạnh rằng Zona thần kinh kh&ocirc;ng chỉ l&agrave; vấn đề c&aacute; nh&acirc;n, m&agrave; c&ograve;n l&agrave; g&aacute;nh nặng y tế cộng đồng, đặc biệt trong bối cảnh d&acirc;n số gi&agrave; h&oacute;a v&agrave; tỷ lệ mắc bệnh mạn t&iacute;nh ng&agrave;y c&agrave;ng gia tăng. BVĐK Hồng Ngọc kỳ vọng trong thời gian tới, nhiều người d&acirc;n thuộc nh&oacute;m nguy cơ cao sẽ tiếp cận sớm v&agrave; đầy đủ c&aacute;c biện ph&aacute;p ph&ograve;ng bệnh Zona, g&oacute;p phần x&acirc;y dựng một cộng đồng khỏe mạnh, chủ động trước bệnh tật.</p>
', '2025-07-19 01:38:08', '2025-07-19 14:06:24', 4);
INSERT INTO swp_db.news (id, title, image_preview, short_description, description, created_at, updated_at, created_by)
VALUES ( 12, 'Những điều bạn cần biết về vắc-xin phòng ho gà'
       , 'https://www.vinmec.com/static/uploads/large_nhieu_nguoi_to_ra_lo_lang_va_muon_biet_noi_soi_dai_trang_co_dau_khong_4c81def2f1.png'
       , 'Bệnh ho gà là một bệnh nhiễm khuẩn rất dễ lây lan, thường xảy ra qua đường hô hấp khi người bị nhiễm hắt hơi hoặc ho. Bệnh không chỉ nguy hiểm mà còn có khả năng lây lan mạnh trong gia đình hoặc những người tiếp xúc gần như người trông trẻ. Một trong những cách hiệu quả nhất để bảo vệ trẻ nhỏ là tiêm vắc-xin DTaP, loại vắc-xin này đồng thời bảo vệ chống lại bệnh uốn ván và bạch hầu.'
       , '<h2>Bệnh ho g&agrave; c&oacute; dễ l&acirc;y kh&ocirc;ng?</h2>

<p>Ho g&agrave; đặc biệt dễ l&acirc;y. Trong m&ocirc;i trường gia đ&igrave;nh, nếu c&oacute; một người mắc bệnh v&agrave; c&aacute;c th&agrave;nh vi&ecirc;n chưa được ti&ecirc;m ph&ograve;ng, nguy cơ l&acirc;y nhiễm l&ecirc;n đến 90%.</p>

<h2>C&oacute; thể mắc bệnh ho g&agrave; nếu đ&atilde; ti&ecirc;m vắc-xin kh&ocirc;ng?</h2>

<p>Vắc-xin ph&ograve;ng ho g&agrave; kh&ocirc;ng cung cấp miễn dịch trọn đời. Hiệu quả bảo vệ sẽ giảm dần sau khoảng 5&ndash;10 năm kể từ khi ti&ecirc;m liều cuối c&ugrave;ng khi c&ograve;n nhỏ. Tuy nhi&ecirc;n, những người đ&atilde; ti&ecirc;m vắc-xin, nếu mắc bệnh, thường chỉ c&oacute; triệu chứng nhẹ hơn v&agrave; &iacute;t biến chứng.</p>

<h2>C&oacute; thể mang vi khuẩn ho g&agrave; m&agrave; kh&ocirc;ng biết kh&ocirc;ng?</h2>

<p>Nếu kh&ocirc;ng c&oacute; triệu chứng, nguy cơ l&acirc;y lan bệnh l&agrave; rất thấp. Nhưng đối với người đ&atilde; ti&ecirc;m ph&ograve;ng, d&ugrave; hiếm gặp, vẫn c&oacute; khả năng xuất hiện c&aacute;c triệu chứng nhẹ giống cảm lạnh v&agrave; sau đ&oacute; chuyển th&agrave;nh ho, trong khi vẫn c&oacute; thể l&acirc;y bệnh cho người kh&aacute;c.</p>

<p><img alt="Trong môi trường gia đình, nếu có một người mắc bệnh và các thành viên chưa được tiêm phòng, nguy cơ lây nhiễm lên đến 90%" src="https://www.vinmec.com/static/uploads/large_nhieu_nguoi_to_ra_lo_lang_va_muon_biet_noi_soi_dai_trang_co_dau_khong_4c81def2f1.png" /></p>

<p>Trong m&ocirc;i trường gia đ&igrave;nh, nếu c&oacute; một người mắc bệnh v&agrave; c&aacute;c th&agrave;nh vi&ecirc;n chưa được ti&ecirc;m ph&ograve;ng, nguy cơ l&acirc;y nhiễm l&ecirc;n đến 90%</p>

<p>&nbsp;</p>

<h2>Trẻ cần bao nhi&ecirc;u mũi vắc-xin DTaP?</h2>

<p>Trẻ nhỏ cần ho&agrave;n th&agrave;nh loạt 5 liều&nbsp;<a href="https://www.vinmec.com/vie/bai-viet/vac-xin-bach-hau-ho-ga-uon-van-tiem-may-mui-vi" target="_blank">vắc-xin DTaP</a>&nbsp;v&agrave;o c&aacute;c thời điểm sau:</p>

<ul>
	<li>2 th&aacute;ng tuổi</li>
	<li>4 th&aacute;ng tuổi</li>
	<li>6 th&aacute;ng tuổi</li>
	<li>15&ndash;18 th&aacute;ng tuổi</li>
	<li>4&ndash;6 tuổi</li>
	<li>Sau liều thứ ba (khoảng 6 th&aacute;ng tuổi), trẻ đạt hiệu quả bảo vệ 80&ndash;85% trong v&ograve;ng 3&ndash;5 năm đầu đời.</li>
</ul>

<h2>C&oacute; cần ti&ecirc;m mũi tăng cường sau khi ho&agrave;n th&agrave;nh c&aacute;c mũi vắc-xin DTaP kh&ocirc;ng?</h2>

<p>Để duy tr&igrave;&nbsp;<a href="https://www.vinmec.com/vie/bai-viet/he-mien-dich-la-gi-tam-quan-trong-cua-he-mien-dich-vi" target="_blank">miễn dịch</a>, tất cả mọi người từ 11 tuổi trở l&ecirc;n cần ti&ecirc;m vắc-xin tăng cường Tdap, đ&acirc;y l&agrave; phi&ecirc;n bản d&agrave;nh cho người lớn kết hợp ph&ograve;ng ho g&agrave;, uốn v&aacute;n v&agrave; bạch hầu. Đặc biệt, phụ nữ mang thai n&ecirc;n ti&ecirc;m vắc-xin Tdap v&agrave;o tuần 27&ndash;36 của thai kỳ để bảo vệ cả mẹ v&agrave; b&eacute;. Với mỗi lần mang thai, mũi ti&ecirc;m n&agrave;y cần được thực hiện lại.</p>

<h2>Rủi ro của vắc-xin DTaP v&agrave; Tdap l&agrave; g&igrave;?</h2>

<p>Vắc-xin ho g&agrave; nh&igrave;n chung rất an to&agrave;n. T&aacute;c dụng phụ thường gặp l&agrave; đỏ, đau hoặc sưng tại vị tr&iacute; ti&ecirc;m, mệt mỏi hoặc&nbsp;<a href="https://www.vinmec.com/vie/bai-viet/sot-nhe-hoi-kho-tho-la-dau-hieu-cua-benh-gi-vi" target="_blank">sốt nhẹ</a>&nbsp;trong 24 giờ sau ti&ecirc;m. Phản ứng dị ứng nghi&ecirc;m trọng cực kỳ hiếm gặp v&agrave; thường &iacute;t rủi ro hơn so với hậu quả của bệnh ho g&agrave;, uốn v&aacute;n hoặc bạch hầu.</p>

<h2>Bảo vệ trẻ trước nguy cơ ho g&agrave;</h2>

<p>Ti&ecirc;m ph&ograve;ng đầy đủ kh&ocirc;ng chỉ gi&uacute;p giảm nguy cơ mắc bệnh m&agrave; c&ograve;n hạn chế l&acirc;y lan trong cộng đồng. Đối với trẻ nhỏ, ho&agrave;n th&agrave;nh lịch ti&ecirc;m vắc-xin đ&uacute;ng thời điểm l&agrave; c&aacute;ch tốt nhất để bảo vệ sức khỏe to&agrave;n diện. Nếu bạn đang băn khoăn về lịch ti&ecirc;m hoặc t&igrave;nh trạng miễn dịch của gia đ&igrave;nh, h&atilde;y tham khảo &yacute; kiến b&aacute;c sĩ để được hướng dẫn cụ thể.</p>
', '2025-07-19 01:38:08', '2025-07-19 14:06:24', 4);
INSERT INTO swp_db.news (id, title, image_preview, short_description, description, created_at, updated_at, created_by)
VALUES ( 13, 'TEST Trung ương thảo luận số lượng đại biểu dự Đại hội Đảng 14', 'https://picsum.photos/600/400'
       , 'Chiều 18/7, Trung ương thảo luận tiêu chuẩn, cơ cấu và phân bổ đại biểu dự Đại hội 14, cùng phương hướng nhân sự và các dự thảo văn kiện trình đại hội.'
       , '<p>Theo th&ocirc;ng c&aacute;o của Văn ph&ograve;ng Trung ương Đảng, nội dung n&agrave;y được đưa ra trong phi&ecirc;n họp buổi chiều, khi Trung ương l&agrave;m việc tại tổ. B&ecirc;n cạnh việc b&agrave;n về đại biểu v&agrave; nh&acirc;n sự, Trung ương cũng g&oacute;p &yacute; cho dự thảo c&aacute;c văn kiện Đại hội theo định hướng mới đ&atilde; thống nhất từ trước.</p>

<p>C&ugrave;ng với đ&oacute;, Trung ương thảo luận việc sửa đổi, bổ sung một số nghị quyết lớn để ho&agrave;n thiện cơ sở ch&iacute;nh trị v&agrave; ph&aacute;p l&yacute; cho mục ti&ecirc;u tiếp tục cải c&aacute;ch, đổi mới đất nước thời gian tới. C&aacute;c lĩnh vực được đặt l&ecirc;n b&agrave;n nghị sự gồm đất đai, x&acirc;y dựng Nh&agrave; nước ph&aacute;p quyền x&atilde; hội chủ nghĩa, gi&aacute;o dục - đ&agrave;o tạo v&agrave; điều chỉnh quy hoạch tổng thể quốc gia giai đoạn 2021-2030, tầm nh&igrave;n đến 2050.</p>

<p><img alt="Phiên khai mạc hội nghị Trung ương 12. Ảnh: Nhật Bắc" src="https://i1-vnexpress.vnecdn.net/2025/07/18/17af90ca0d51bb0fe240-175283912-6455-6579-1752839167.jpg?w=680&amp;h=0&amp;q=100&amp;dpr=1&amp;fit=crop&amp;s=c8rOj0o3uuIVRNHHAcczpw" /></p>

<p>Phi&ecirc;n khai mạc hội nghị Trung ương 12. Ảnh:&nbsp;<em>Nhật Bắc</em></p>

<p>S&aacute;ng c&ugrave;ng ng&agrave;y, Trung ương l&agrave;m việc tại hội trường. Tổng B&iacute; thư T&ocirc; L&acirc;m ph&aacute;t biểu khai mạc hội nghị; Chủ tịch nước Lương Cường điều h&agrave;nh.</p>

<p>Trung ương đ&atilde; thống nhất phương &aacute;n ho&agrave;n thiện c&aacute;c dự thảo văn kiện tr&igrave;nh Đại hội 14. Trong đ&oacute;, b&aacute;o c&aacute;o ch&iacute;nh trị mới sẽ t&iacute;ch hợp nội dung của ba b&aacute;o c&aacute;o trước đ&acirc;y gồm: b&aacute;o c&aacute;o ch&iacute;nh trị, b&aacute;o c&aacute;o kinh tế x&atilde; hội v&agrave; b&aacute;o c&aacute;o tổng kết c&ocirc;ng t&aacute;c x&acirc;y dựng Đảng, thi h&agrave;nh Điều lệ Đảng; b&aacute;o c&aacute;o thi h&agrave;nh Điều lệ Đảng v&agrave; b&aacute;o c&aacute;o tổng kết một số vấn đề l&yacute; luận, thực tiễn về c&ocirc;ng cuộc đổi mới theo định hướng x&atilde; hội chủ nghĩa sau 40 năm.</p>

<p>Cũng trong phi&ecirc;n buổi s&aacute;ng, Trung ương thực hiện một số nội dung li&ecirc;n quan đến c&ocirc;ng t&aacute;c c&aacute;n bộ.</p>

<p>Hội nghị Trung ương 12 kh&oacute;a 13 khai mạc s&aacute;ng 18/7, dự kiến k&eacute;o d&agrave;i đến hết ng&agrave;y 19/7. Ba nh&oacute;m nội dung lớn được tập trung thảo luận gồm c&ocirc;ng t&aacute;c chuẩn bị Đại hội 14; x&acirc;y dựng cơ sở ch&iacute;nh trị, ph&aacute;p l&yacute; nhằm tiếp tục cải c&aacute;ch, đổi mới đất nước; v&agrave; c&ocirc;ng t&aacute;c c&aacute;n bộ.</p>
', '2025-07-19 01:38:08', '2025-07-19 04:04:54', 4);
INSERT INTO swp_db.news (id, title, image_preview, short_description, description, created_at, updated_at, created_by)
VALUES ( 14, 'Biển súc – Vị thuốc quý và những công dụng đối với sức khỏe'
       , 'https://cdn.youmed.vn/tin-tuc/wp-content/uploads/2022/08/Bien-suc-Mot-loai-cay-duoc-lieu-quy-de-trong-trong-vuon-nha-scaled.jpg'
       , 'Khi nói đến biển súc, chắc hẳn nhiều người sẽ không quen thuộc lắm khi dùng tên gọi này. Tuy nhiên, biển súc còn có tên gọi khác là rau đắng. Có lẽ khi nghe đến rau đắng, ai nấy đều thấy thân quen. Không chỉ được đưa vào lời của bài hát, rau đắng còn có những lợi ích sức khỏe khác. Cùng Thạc sĩ, Bác sĩ Nguyễn Thị Lệ Quyên tìm hiểu về biển súc hay rau đắng qua bài viết dưới đây.'
       , '<h2>Giới thiệu chung</h2>

<p>Biển s&uacute;c c&ograve;n c&oacute; những t&ecirc;n gọi kh&aacute;c như c&acirc;y c&agrave;ng t&ocirc;m, c&acirc;y xương c&aacute; ngo&agrave;i t&ecirc;n gọi rau đắng m&agrave; ta thường nghe.</p>

<p>T&ecirc;n khoa học của Biển s&uacute;c l&agrave;&nbsp;<em>Polygonum aviculare L.</em>&nbsp;Thuộc họ Rau răm&nbsp;<em>Polygonaceae.</em></p>

<h3>M&ocirc; tả<a href="https://youmed.vn/tin-tuc/bien-suc/#cite-1">1</a>&nbsp;<a href="https://youmed.vn/tin-tuc/bien-suc/#cite-2">2</a></h3>

<p>C&acirc;y thảo nhỏ, mọc b&ograve;, th&acirc;n v&agrave; c&agrave;nh mọc tỏa tr&ograve;n gần s&aacute;t mặt đất, m&agrave;u đỏ t&iacute;m. Đ&ocirc;i khi c&acirc;y c&oacute; thể cao tới 10 &ndash; 30 cm. L&aacute; nhỏ, mọc so le. Phiến l&aacute; của c&acirc;y thường d&agrave;i 1,5 &ndash; 2 cm, rộng 0,4 cm.</p>

<p>Hoa nhỏ m&agrave;u hồng t&iacute;m, mọc tụ từ 1 &ndash; 5, thường từ 3 &ndash; 4 hoa ở kẽ l&aacute;. Quả mọc ở cạnh, chứa một hạt đầu đen. M&ugrave;a hoa th&aacute;ng 5 &ndash; 6, k&eacute;o d&agrave;i suốt m&ugrave;a h&egrave;.</p>

<h3>Ph&acirc;n bố sinh th&aacute;i<a href="https://youmed.vn/tin-tuc/bien-suc/#cite-1">1</a>&nbsp;<a href="https://youmed.vn/tin-tuc/bien-suc/#cite-2">2</a></h3>

<p>Biển s&uacute;c ph&acirc;n bố phổ biến ở v&ugrave;ng nhiệt đới hoặc cận nhiệt đới Ch&acirc;u &Aacute;, bao gồm Trung Quốc, L&agrave;o, Ấn Độ, Th&aacute;i Lan, Mianma, Malaysia&hellip;</p>

<p>Ở Việt Nam, c&acirc;y cũng ph&acirc;n bố ở nhiều nơi, từ đồng bằng đến trung du v&agrave; v&ugrave;ng n&uacute;i thấp. C&acirc;y ưa ẩm, hơi chịu b&oacute;ng, thường mọc th&agrave;nh đ&aacute;m ở ruộng trồng hoa m&agrave;u, b&atilde;i s&ocirc;ng, nương rẫy, vườn v&agrave; ven đường đi. C&acirc;y con mọc từ hạt xuất hiện v&agrave;o cuối m&ugrave;a xu&acirc;n, ra quả v&agrave;o m&ugrave;a h&egrave; v&agrave; cuối thu th&igrave; t&agrave;n lụi. V&ograve;ng đời của c&acirc;y thường k&eacute;o d&agrave;i khoảng 4 &ndash; 6 th&aacute;ng t&ugrave;y nơi mọc.</p>

<p><img alt="Biển súc - Một loại cây dược liệu quý dễ trồng trong vườn nhà" src="https://cdn.youmed.vn/tin-tuc/wp-content/uploads/2022/08/Bien-suc-Mot-loai-cay-duoc-lieu-quy-de-trong-trong-vuon-nha-scaled.jpg" style="height:379px; width:600px" /></p>

<p>Biển s&uacute;c &ndash; Một loại c&acirc;y dược liệu qu&yacute; dễ trồng trong vườn nh&agrave;</p>

<h3>Bộ phận d&ugrave;ng</h3>

<p>D&ugrave;ng to&agrave;n c&acirc;y, thu h&aacute;i v&agrave;o l&uacute;c ra hoa, c&oacute; thể d&ugrave;ng tươi hoặc phơi kh&ocirc;.</p>

<p><img alt="Biển súc dùng toàn cây dạng tươi hoặc phơi khô để làm thuốc" src="https://cdn.youmed.vn/tin-tuc/wp-content/uploads/2022/08/Bien-suc-dung-toan-cay-dang-tuoi-hoac-phoi-kho-de-chua-benh.jpg" style="height:407px; width:600px" /></p>

<p>Biển s&uacute;c d&ugrave;ng to&agrave;n c&acirc;y dạng tươi hoặc phơi kh&ocirc; để l&agrave;m thuốc</p>

<h3>Th&agrave;nh phần h&oacute;a học</h3>

<p>Dược liệu n&agrave;y chứa tinh dầu, avicularin, quercitrin, emodin, c&aacute;c sắc tố flavon, avicularosid, tannin, acid silicic. Ngo&agrave;i ra c&ograve;n c&oacute;&nbsp;<a href="https://youmed.vn/tin-tuc/nhung-dieu-ban-chua-biet-ve-vitamin-c/">vitamin C</a>, carotin, đường, tinh dầu, nhựa, s&aacute;p.</p>

<h2>Lợi &iacute;ch sức khỏe của biển s&uacute;c</h2>

<p>Một số lợi &iacute;ch của dược liệu được nghi&ecirc;n cứu như sau:<a href="https://youmed.vn/tin-tuc/bien-suc/#cite-3">3</a></p>

<h3>Ung thư</h3>

<p>Khi n&oacute;i đến việc t&igrave;m ra phương ph&aacute;p điều trị ung thư. Ng&agrave;y c&agrave;ng c&oacute; nhiều loại thảo mộc được đ&aacute;nh gi&aacute; về đặc t&iacute;nh chống u v&agrave; khả năng ức chế sự tăng sinh của tế b&agrave;o ung thư. C&aacute;c nh&agrave; nghi&ecirc;n cứu kết luận rằng c&aacute;c hợp chất phenolic c&oacute; trong biển s&uacute;c c&oacute; t&aacute;c dụng chống oxy h&oacute;a v&agrave; chống khối u mạnh mẽ. Tuy nhi&ecirc;n, việc nghi&ecirc;n cứu dược liệu n&agrave;y c&ograve;n ở bước đầu v&agrave; cần nhiều nghi&ecirc;n cứu hơn nữa trước khi c&oacute; thể x&aacute;c nhận hiệu quả của n&oacute;.</p>

<h3>Hỗ trợ hệ hộ hấp</h3>

<p>Biển s&uacute;c được d&ugrave;ng để điều trị c&aacute;c triệu chứng của cảm lạnh th&ocirc;ng thường. N&oacute; c&oacute; đặc t&iacute;nh long đờm tự nhi&ecirc;n cũng như khả năng chống vi&ecirc;m c&oacute; thể gi&uacute;p giải ph&oacute;ng chất nhờn khỏi đường thở. Tuy nhi&ecirc;n, cần c&oacute; nhiều nghi&ecirc;n cứu hơn nữa để khẳng định t&aacute;c dụng của dược liệu n&agrave;y.</p>

<h3>T&aacute;c dụng tr&ecirc;n hệ tim mạch</h3>

<p>Biển s&uacute;c chứa silica v&agrave; flavonoid được biết l&agrave; c&oacute; t&aacute;c dụng cải thiện độ bền của mạch m&aacute;u. Ngo&agrave;i ra c&ograve;n gi&uacute;p điều h&ograve;a lưu th&ocirc;ng m&aacute;u v&agrave; giảm stress th&agrave;nh mạch. Do đ&oacute; gi&uacute;p ngăn ngừa chứng xơ vữa động mạch v&agrave; đột quỵ tim.</p>

<h3>Vi&ecirc;m nướu</h3>

<p>Vi&ecirc;m nướu l&agrave; trạng tổn thương vi&ecirc;m cấp hay m&atilde;n t&iacute;nh xảy ra ở tổ chức phần mềm xung quanh răng. Vi&ecirc;m nướu g&acirc;y ra c&aacute;c cơn đau v&agrave; kh&oacute; chịu ở miệng, thường được điều trị bằng thuốc kh&aacute;ng sinh. Do nguy cơ t&aacute;c dụng phụ v&agrave; mối lo ngại ng&agrave;y c&agrave;ng tăng về t&igrave;nh trạng kh&aacute;ng thuốc kh&aacute;ng sinh, c&aacute;c nh&agrave; nghi&ecirc;n cứu đ&atilde; xem x&eacute;t về c&aacute;c biện ph&aacute;p từ thảo dược.</p>

<p>Nghi&ecirc;n cứu đ&aacute;nh gi&aacute; hiệu quả của Polygonum aviculare đối với bệnh vi&ecirc;m lợi. Tuy nhi&ecirc;n, ch&uacute;ng ta vẫn cần nhiều nghi&ecirc;n cứu hơn để chứng minh t&aacute;c dụng n&agrave;y.</p>

<h2>T&aacute;c dụng theo Y học cổ truyền</h2>

<h3>T&iacute;nh vị, c&ocirc;ng năng</h3>

<p>Biển s&uacute;c c&oacute; vị đắng nhạt, t&iacute;nh b&igrave;nh, kh&ocirc;ng độc. Quy kinh vị v&agrave; bang quang. C&oacute; t&aacute;c dụng lợi tiểu, ti&ecirc;u sưng, giải độc, s&aacute;t tr&ugrave;ng</p>

<h3>C&ocirc;ng dụng</h3>

<p>Biển s&uacute;c được dung chữa kiết lị,&nbsp;<a href="https://youmed.vn/tin-tuc/tao-bon-va-nhung-hieu-biet-co-ban-doi-voi-nguoi-benh/">t&aacute;o b&oacute;n</a>, tiểu kh&oacute; do vi&ecirc;m hoặc&nbsp;<a href="https://youmed.vn/tin-tuc/nhung-dieu-ban-can-biet-ve-soi-than/">sỏi thận</a>, giun s&aacute;n&hellip;</p>

<h3>Liều d&ugrave;ng</h3>

<p>10 &ndash; 20 g dược liệu kh&ocirc; nấu nước uống. Ngo&agrave;i ra c&ograve;n c&oacute; thể dung biển s&uacute;c tươi gi&atilde; n&aacute;t, th&ecirc;m nước gạn uống, b&atilde; đắp, chữa rắn cắn.</p>

<h2>B&agrave;i thuốc chứa biển s&uacute;c</h2>

<p>Một số b&agrave;i thuốc chứa biển s&uacute;c như sau:<a href="https://youmed.vn/tin-tuc/bien-suc/#cite-1">1</a>&nbsp;<a href="https://youmed.vn/tin-tuc/bien-suc/#cite-2">2</a></p>

<h3>Hỗ trợ điều trị vi&ecirc;m b&agrave;ng quang</h3>

<p>Biển s&uacute;c 12 g;&nbsp;<a href="https://youmed.vn/tin-tuc/ty-giai-vi-thuoc-loi-tieu-tuyet-voi/">Tỳ giải</a>,&nbsp;<a href="https://youmed.vn/tin-tuc/bo-cong-anh-va-cau-chuyen-ve-su-biet-on/">bồ c&ocirc;ng anh</a>, mỗi vị 20 g;&nbsp;<a href="https://youmed.vn/tin-tuc/sai-ho-vi-thuoc-de-giai-con-uat/">s&agrave;i hồ</a>,&nbsp;<a href="https://youmed.vn/tin-tuc/hoang-cam-mot-cau-chuyen-buon-va-khang-sinh-dong-y/">ho&agrave;ng cầm</a>,&nbsp;<a href="https://youmed.vn/tin-tuc/hoat-thach-loai-khoang-chat-dung-bao-ve-niem-mac-va-da/">hoạt thạch</a>,&nbsp;<a href="https://youmed.vn/tin-tuc/cay-cu-mach/">c&ugrave; mạch</a>, mỗi vị 12 g;&nbsp;<a href="https://youmed.vn/tin-tuc/moc-thong-vi-thuoc-co-cong-dung-loi-tieu/">mộc th&ocirc;ng</a>&nbsp;6 g. Nếu<a href="https://youmed.vn/tin-tuc/dai-mau-co-nguy-hiem-khong/">&nbsp;tiểu ra m&aacute;u</a>, th&ecirc;m&nbsp;<a href="https://youmed.vn/tin-tuc/sinh-dia-vi-thuoc-mat-lanh-bo-than-bo-huyet/">sinh địa</a>,&nbsp;<a href="https://youmed.vn/tin-tuc/chi-tu-vi-thuoc-thanh-nhiet/">chi tử</a>&nbsp;sao đen, rễ c&oacute; tranh, mỗi vị 12 g. Sắc uống ng&agrave;y 1 thang.</p>

<h3>Chữa tiểu &iacute;t v&agrave; kh&oacute;</h3>

<p>Biển s&uacute;c, mộc th&ocirc;ng, xa tiền, c&ugrave; mạch, sơn chi tử, hoạt thạch mỗi vị 12 g.&nbsp;<a href="https://youmed.vn/tin-tuc/dai-hoang-tuong-quan-trong-lang-thuoc-xo/">Đại ho&agrave;ng</a>&nbsp;8 g,&nbsp;<a href="https://youmed.vn/tin-tuc/chich-thao/">ch&iacute;ch thảo</a>&nbsp;6 g. Sắc uống ng&agrave;y 01 thang.</p>

<h3>Hỗ trợ giảm sưng tấy, đau nhức</h3>

<p>Biển s&uacute;c kh&ocirc; băm nhỏ rồi ng&acirc;m rượu, dung xoa b&oacute;p hang ng&agrave;y. Hoặc dung c&acirc;y tươi 15 &ndash; 20 g gi&atilde; n&aacute;t, th&ecirc;m nước uống.</p>

<p>Hỗ trợ chữa rắn cắn, trẻ đau bụng giun.</p>

<p>Biển s&uacute;c, cỏ nọc rắn, mỗi vị 40 &ndash; 60 g. Sắc uống.</p>

<h2>Lưu &yacute; khi d&ugrave;ng biển s&uacute;c</h2>

<p>Đ&ocirc;̣c tính: Bi&ecirc;̉n súc được xem là tương đối &nbsp;an toàn với người nhưng kh&ocirc;ng n&ecirc;n dùng làm thức ăn cho đ&ocirc;̣ng v&acirc;̣t như ngựa, cừu vì có th&ecirc;̉ g&acirc;y r&ocirc;́i loạn ti&ecirc;u hóa. Nh&acirc;́t là chim b&ocirc;̀ c&acirc;u v&igrave; ch&uacute;ng r&acirc;́t m&acirc;̃n cảm với đ&ocirc;̣c tính của bi&ecirc;̉n súc. B&ecirc;n cạnh đó, đ&ocirc;̣c tính của bi&ecirc;̉n súc khi nghi&ecirc;n cứu tr&ecirc;n thỏ v&agrave; m&egrave;o cho thấy li&ecirc;̀u g&acirc;y ch&ecirc;́t bằng đường u&ocirc;́ng là 20 mg/ kg th&ecirc;̉ trọng.</p>

<p>Bi&ecirc;̉n súc có vị đắng, tính hàn. Vì v&acirc;̣y, kh&ocirc;ng n&ecirc;n lạm dụng dung đ&ecirc;̉ tránh làm hao t&ocirc;̉n tinh khí.</p>

<p>Với những t&aacute;c dụng hỗ trợ điều trị bệnh m&agrave;&nbsp;<strong>biển s&uacute;c</strong>&nbsp;mang lại, kh&ocirc;ng c&oacute; g&igrave; kh&oacute; hiểu khi biển s&uacute;c lại được xem l&agrave; loại thảo dược rất đ&aacute;ng để trồng trong vườn nh&agrave;. Tuy nhi&ecirc;n, khi sử dụng biển s&uacute;c, cần thận trọng hỏi &yacute; kiến b&aacute;c sĩ để tr&aacute;nh những rủi ro kh&ocirc;ng đ&aacute;ng c&oacute;.</p>
', '2025-07-19 01:38:08', '2025-07-19 14:06:24', 4);
