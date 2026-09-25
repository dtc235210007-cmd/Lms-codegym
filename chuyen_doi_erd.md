Bước 1: Xác định các thực thể và thuộc tính trong ERD
PhieuXuat (Phiếu xuất / Giao hàng): SoPX (khóa chính), NgayXuat.

VatTu (Vật tư / Hàng hóa): MaVTU (khóa chính), TenVTU.

DonDH (Đơn đặt hàng): SoDH (khóa chính), NgayDH.

NhaCC (Nhà cung cấp / Đơn vị khách): MaNCC (khóa chính), TenNCC, DiaChi.

Thuộc tính đa trị: SoDienThoai của Nhà cung cấp (một nhà cung cấp có thể có nhiều số điện thoại).

Bước 2: Phân tích các mối quan hệ (Relationships)
Quan hệ 1 - n giữa NhaCC và DonDH (Cung cấp):

Một nhà cung cấp có thể nhận nhiều đơn đặt hàng.

Chuyển khóa chính MaNCC từ bảng NhaCC sang làm khóa ngoại trong bảng DonDH.

Quan hệ n - m giữa DonDH và VatTu (Đặt hàng):

Một đơn hàng đặt nhiều mặt hàng; một mặt hàng có thể nằm ở nhiều đơn hàng.

Tách thành bảng trung gian ChiTietDonHang (hoặc ChiTietDatHang).

Khóa chính kết hợp gồm: (SoDH, MaVTU).

Thuộc tính riêng của quan hệ: SoLuongDat.

Quan hệ n - m giữa PhieuXuat và VatTu (Xuất hàng):

Một phiếu xuất xuất nhiều vật tư; một vật tư xuất ở nhiều phiếu.

Tách thành bảng trung gian ChiTietPhieuXuat.

Khóa chính kết hợp gồm: (SoPX, MaVTU).

Thuộc tính riêng của quan hệ: DGXuat (Đơn giá xuất), SLXuat (Số lượng xuất).

Bước 3: Xử lý thuộc tính đa trị
Thuộc tính SoDienThoai của NhaCC là đa trị.

Tách thành một bảng riêng: SDT_NhaCC (hoặc NhaCC_DienThoai).

Thuộc tính: MaNCC, SoDienThoai.

Khóa chính: kết hợp (MaNCC, SoDienThoai).

Khóa ngoại: MaNCC tham chiếu tới NhaCC(MaNCC).

Bước 4: Danh sách các bảng sau khi chuyển đổi hoàn chỉnh
Dưới đây là lược đồ cơ sở dữ liệu quan hệ (các trường gạch chân hoặc in đậm ký hiệu (PK) là khóa chính, (FK) là khóa ngoại):

NhaCC (

MaNCC [PK],

TenNCC,

DiaChi
)

SDT_NhaCC (

MaNCC [PK, FK tham chiếu NhaCC(MaNCC)],

SoDienThoai [PK]
)

DonDH (

SoDH [PK],

NgayDH,

MaNCC [FK tham chiếu NhaCC(MaNCC)]
)

VatTu (

MaVTU [PK],

TenVTU
)

ChiTietDonHang (

SoDH [PK, FK tham chiếu DonDH(SoDH)],

MaVTU [PK, FK tham chiếu VatTu(MaVTU)],

SoLuongDat
)

PhieuXuat (

SoPX [PK],

NgayXuat
)

ChiTietPhieuXuat (

SoPX [PK, FK tham chiếu PhieuXuat(SoPX)],

MaVTU [PK, FK tham chiếu VatTu(MaVTU)],

DGXuat,

SLXuat
)
