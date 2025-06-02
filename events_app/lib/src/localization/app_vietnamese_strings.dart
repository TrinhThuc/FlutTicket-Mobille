// File: lib/src/localization/app_vietnamese_strings.dart

class AppVietnameseStrings {
  static const String welcome = 'Chào mừng!';
  static const String signInOrCreateAccount = 'Đăng nhập hoặc tạo tài khoản mới';
  static const String signIn = 'Đăng nhập';
  static const String noAccountSignUp = 'Chưa có tài khoản? Đăng ký';

  // Login Screen
  static const String plsEnterEmailPassword = 'Vui lòng nhập email và mật khẩu';
  static const String errorOccurredPleaseTryAgain = 'Có lỗi xảy ra, vui lòng thử lại';
  static const String welcomeBack = 'Chào mừng trở lại!';
  static const String emailAddress = 'Địa chỉ Email';
  static const String emailHint = 'ten@vidu.com';
  static const String password = 'Mật khẩu';
  static const String enterYourPasswordHint = 'Nhập mật khẩu của bạn';

  // SignUp Screen
  static const String passwordsDoNotMatch = 'Mật khẩu xác nhận không khớp';
  static const String createNewAccount = 'Tạo tài khoản mới';
  static const String fullName = 'Họ và tên';
  static const String enterYourNameHint = 'Nhập họ và tên của bạn';
  static const String createPassword = 'Tạo mật khẩu';
  static const String repeatPassword = 'Lặp lại mật khẩu';
  static const String repeatNewPasswordHint = 'Lặp lại mật khẩu mới';
  static const String signUp = 'Đăng ký';

  // Ticket Detail Screen
  static const String errorNoDataReceived = 'Lỗi: Không nhận được dữ liệu';
  static const String errorPrefix = 'Lỗi'; // Cho 'Lỗi: $e'
  static const String retry = 'Thử lại';
  static const String ticketDetailTitle = 'Chi tiết vé';
  static const String eventDetailSectionTitle = 'Chi tiết sự kiện';
  static const String eventLabel = 'Sự kiện';
  static const String dateTimeLabel = 'Ngày & Giờ';
  static const String locationLabel = 'Địa điểm';
  static const String organizerLabel = 'Nhà tổ chức';
  static const String orderInformationSectionTitle = 'Thông tin đơn hàng';
  static const String emailLabel = 'Email'; // Phân biệt với emailAddress là label cho input field
  static const String phoneLabel = 'Điện thoại';
  static const String genderLabel = 'Giới tính';
  static const String female = 'Nữ';
  static const String male = 'Nam';
  static const String statusLabel = 'Trạng thái';
  static const String statusPendingPayment = 'Chờ thanh toán'; // Đã có, nhưng thêm để nhất quán
  static const String statusPaid = 'Đã thanh toán'; // Đã có, nhưng thêm để nhất quán
  static const String statusPaymentFailed = 'Thanh toán thất bại'; // Đã có, nhưng thêm để nhất quán
  static const String statusUnknown = 'Không xác định'; // Đã có, nhưng thêm để nhất quán
  static const String paymentMethodLabel = 'Phương thức thanh toán';
  static const String refIdLabel = 'Mã tham chiếu';
  static const String ticketDetailsSectionTitle = 'Chi tiết vé (loại vé)';
  static const String noQrCodeForTicket = 'Không có mã QR cho vé này';
  static const String totalAmountLabel = 'Tổng cộng';
  static const String shareEventButton = 'Chia sẻ sự kiện'; // Đã có 'Chia sẻ sự kiện' trong SnackBar, đây là cho button
  static const String downloadButton = 'Tải xuống';
  static const String payNowButton = 'THANH TOÁN NGAY';
  static const String contactSupportButton = 'LIÊN HỆ HỖ TRỢ';

  // Update Info Screen
  static const String errorNoValidUserData = 'Lỗi: Không nhận được dữ liệu người dùng hợp lệ';
  static const String updateInfoTitle = 'Cập nhật thông tin';
  static const String phoneNumberLabel = 'Số điện thoại'; // Phân biệt với phoneLabel có thể dùng ở chỗ khác
  static const String enterPhoneNumberHint = 'Nhập số điện thoại';
  static const String addressLabel = 'Địa chỉ';
  static const String enterAddressHint = 'Nhập địa chỉ';
  static const String updateButton = 'Cập nhật';
  static const String errorUpdateInfoFailed = 'Lỗi: Cập nhật thông tin không thành công';

  // Profile Screen
  static const String errorNoFileSelected = 'Lỗi: Không có tệp nào được chọn.';
  static const String pickedFilePathDebug = 'Đường dẫn tệp đã chọn: '; // Cho debugPrint
  static const String errorFailedToUploadImage = 'Lỗi: Không thể tải lên hình ảnh.';
  static const String settingsTitle = 'Cài đặt';
  static const String logOutButton = 'Đăng xuất';
  static const String confirmLogOutMessage = 'Bạn có chắc chắn muốn đăng xuất không?';
  static const String primaryCityLabel = 'Thành phố chính';
  static const String copyEventToCalendarLabel = 'Sao chép sự kiện vào lịch';

  // Ticket Screen
  static const String ticketsTitle = 'Vé của tôi'; // Hoặc 'Quản lý vé'
  static const String upcomingTab = 'Sắp diễn ra';
  static const String pastTicketsTab = 'Đã qua';
  static const String allTab = 'Tất cả';
  static const String noDataFound = 'Không tìm thấy dữ liệu'; // Cho print và có thể cho UI
  static const String noEvents = 'Không có sự kiện nào';
  static const String statusUndefined = 'Trạng thái không xác định'; // Dùng chung với statusUnknown hoặc riêng nếu cần

  // Buy Ticket Screen
  static const String eventNameUnavailable = 'Tên sự kiện không có';
  static const String timePrefix = 'Thời gian: ';
  static const String noInformationAvailable = 'Không có thông tin';
  static const String locationUnavailable = 'Địa điểm không có';
  static const String buyNowButtonShort = 'Mua';
  static const String plsSelectAtLeastOneTicket = 'Vui lòng chọn ít nhất 1 vé';
  static const String enterVoucherCodeLabel = 'Nhập mã voucher';
  static const String ticketTypeUnavailable = 'Loại vé không có';
  static const String onSaleUntilPrefix = 'Bán đến: ';

  // Single Event Screen
  static const String eventDataEmptyOrInvalid = 'Dữ liệu sự kiện rỗng hoặc không hợp lệ';
  static const String viewOnMap = 'Xem trên bản đồ';
  static const String refundPolicyTitle = 'Chính sách hoàn tiền';
  static const String flutFeeNonRefundable = 'Phí Flut không hoàn lại.';
  static const String aboutSectionTitle = 'Giới thiệu';
  static const String descriptionUnavailable = 'Mô tả không có';
  static const String addToCalendar = 'Thêm vào lịch';
  static const String eventOrganizerTitle = 'Nhà tổ chức sự kiện';
  static const String getTicketsButton = 'Nhận vé';

  // Select Location Screen
  static const String mostSearchedTitle = 'Tìm kiếm nhiều nhất';
  static const String helloGreeting = 'Xin chào!';
  static const String findYourNextEventMessage = 'Cùng tìm sự kiện tiếp theo của bạn.\nChọn một địa điểm.';
  static const String selectLocationHint = 'Chọn địa điểm....';

  // Search Screen
  static const String errorNoPopularEvents = 'Lỗi: Không nhận được dữ liệu sự kiện phổ biến';
  static const String errorNoEventTypes = 'Lỗi: Không nhận được dữ liệu loại sự kiện hợp lệ';
  static const String errorNoSearchResults = 'Lỗi: Không nhận được dữ liệu tìm kiếm sự kiện';
  static const String searchForHint = 'Tìm kiếm....';
  static const String filtersTitle = 'Bộ lọc';
  static const String openFiltersButton = 'Mở bộ lọc';
  static const String eventTypeFilterPrefix = 'Loại sự kiện: ';
  static const String startDateFilterPrefix = 'Ngày bắt đầu: ';
  static const String endDateFilterPrefix = 'Ngày kết thúc: ';
  static const String locationFilterPrefix = 'Địa điểm: ';
  static const String eventsSuffix = ' Sự kiện'; // Kèm khoảng trắng ở đầu
  static const String sortByRelevant = 'Sắp xếp theo liên quan';
  static const String savedEventsTitle = 'Sự kiện đã lưu'; // Thêm nếu cần
  static const String seeAllButton = 'Xem tất cả'; // Thêm nếu cần

  // Payment Screen
  static const String enterContactInfoTitle = 'Nhập các thông tin';
  static const String plsEnterFullName = 'Vui lòng nhập họ và tên';
  static const String plsEnterPhoneNumber = 'Vui lòng nhập số điện thoại';
  static const String otherGender = 'Khác';
  static const String plsSelectGender = 'Vui lòng chọn giới tính';
  static const String plsEnterEmail = 'Vui lòng nhập email';
  static const String plsEnterAddress = 'Vui lòng nhập địa chỉ';
  static const String paymentMethodsTitle = 'Phương thức thanh toán';
  static const String termsAndConditionsMessage = 'Khi tiếp tục, bạn đồng ý với Điều khoản & Điều kiện và Chính sách hoàn tiền của chúng tôi.';
  static const String totalLabel = 'Tổng cộng'; // Phân biệt với totalAmountLabel
  static const String checkOutButton = 'Thanh toán'; // Hoặc 'Hoàn tất đặt vé'
  static const String plsFillAllInfoToast = 'Vui lòng điền đầy đủ thông tin';
  static const String processingToast = 'Đang xử lý...';
  static const String bookingSuccessfulToast = 'Đặt vé thành công!';
  static const String bookingSuccessfulAnDirectPaymentToast = 'Đặt vé thành công, đang chuyển hướng đến trang thanh toán';
  static const String bookingFailedToastPrefix = 'Đặt vé thất bại: ';
  static const String bookingFailedToastNoPaymentUrl = 'Không thể tạo URL thanh toán';
  static const String bookingFailedToastNoOrderId = 'Không có ID đơn hàng hợp lệ';
  static const String bookingFailedToastGeneralError = 'Đã xảy ra lỗi chung';

  // Home Screen
  static const String newLabel = 'Mới';
  static const String errorNoFavoriteEvents = 'Lỗi: Không nhận được dữ liệu sự kiện yêu thích';
  // errorNoValidUserData hoặc eventDataEmptyOrInvalid có thể dùng cho lỗi dữ liệu chung
  static const String popularInPrefix = 'Phổ biến tại '; // Thêm $selectedLocation sau
  // seeAllButton đã có (nếu có)

  // Favourites Screen
  // errorNoFavoriteEvents đã có
  static const String noFavoritesYetTitle = 'Chưa có mục yêu thích nào';
  static const String loginToSaveFavoritesMessage = 'Hãy đảm bảo bạn đã đăng nhập để lưu các sự kiện yêu thích của mình';
  static const String addToFavoritesButton = 'Thêm vào yêu thích';
  static const String favoritesTitle = 'Yêu thích';
  // noInformationAvailable, eventNameUnavailable, locationUnavailable có thể dùng cho các fallback

  // Filter Screen
  static const String applyButton = 'Áp dụng';
  static const String eventTypeLabel = 'Loại sự kiện';
  static const String allEventTypes = 'Tất cả loại sự kiện';
  static const String locationFilterLabel = 'Địa điểm *';
  static const String enterLocationHint = 'Nhập địa điểm';
  static const String plsEnterLocation = 'Vui lòng nhập địa điểm';
  static const String selectStartDateButton = 'Chọn ngày bắt đầu';
  static const String selectEndDateButton = 'Chọn ngày kết thúc';
  static const String searchContentLabel = 'Nội dung tìm kiếm';
  static const String enterSearchContentHint = 'Nhập nội dung tìm kiếm';

  // Ticket Detail Screen (Retry & Additions)
  static const String errorCreatingPaymentUrl = 'Không tạo được URL thanh toán';
  static const String errorOccurredCreatingPaymentUrl = 'Đã xảy ra lỗi khi tạo URL thanh toán';
  static const String closeButton = 'Đóng';

  // Thêm các chuỗi khác ở đây nếu cần
} 