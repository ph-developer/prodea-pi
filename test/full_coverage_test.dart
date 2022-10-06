// ignore_for_file: unused_import
import 'package:prodea/core/errors/failures.dart';
import 'package:prodea/core/extensions/date_time.dart';
import 'package:prodea/core/extensions/string.dart';
import 'package:prodea/core/input_formatters.dart';
import 'package:prodea/firebase_options.dart';
import 'package:prodea/injector.dart';
import 'package:prodea/main.dart';
import 'package:prodea/router.dart';
import 'package:prodea/src/data/dtos/city_dto.dart';
import 'package:prodea/src/data/dtos/donation_dto.dart';
import 'package:prodea/src/data/dtos/firebase_dto.dart';
import 'package:prodea/src/data/dtos/user_dto.dart';
import 'package:prodea/src/data/repositories/local/json_city_local_repo.dart';
import 'package:prodea/src/data/repositories/remote/firebase_auth_remote_repo.dart';
import 'package:prodea/src/data/repositories/remote/firebase_donation_remote_repo.dart';
import 'package:prodea/src/data/repositories/remote/firebase_file_remote_repo.dart';
import 'package:prodea/src/data/repositories/remote/firebase_user_remote_repo.dart';
import 'package:prodea/src/data/services/asuka_notification_service.dart';
import 'package:prodea/src/data/services/connectivity_network_service.dart';
import 'package:prodea/src/data/services/go_router_navigation_service.dart';
import 'package:prodea/src/data/services/image_picker_photo_service.dart';
import 'package:prodea/src/domain/dtos/city_dto.dart';
import 'package:prodea/src/domain/dtos/donation_dto.dart';
import 'package:prodea/src/domain/dtos/user_dto.dart';
import 'package:prodea/src/domain/entities/city.dart';
import 'package:prodea/src/domain/entities/donation.dart';
import 'package:prodea/src/domain/entities/user.dart';
import 'package:prodea/src/domain/repositories/auth_repo.dart';
import 'package:prodea/src/domain/repositories/city_repo.dart';
import 'package:prodea/src/domain/repositories/donation_repo.dart';
import 'package:prodea/src/domain/repositories/file_repo.dart';
import 'package:prodea/src/domain/repositories/user_repo.dart';
import 'package:prodea/src/domain/services/navigation_service.dart';
import 'package:prodea/src/domain/services/network_service.dart';
import 'package:prodea/src/domain/services/notification_service.dart';
import 'package:prodea/src/domain/services/photo_service.dart';
import 'package:prodea/src/domain/usecases/auth/do_login.dart';
import 'package:prodea/src/domain/usecases/auth/do_logout.dart';
import 'package:prodea/src/domain/usecases/auth/do_register.dart';
import 'package:prodea/src/domain/usecases/auth/get_current_user.dart';
import 'package:prodea/src/domain/usecases/auth/send_password_reset_email.dart';
import 'package:prodea/src/domain/usecases/cities/get_cities.dart';
import 'package:prodea/src/domain/usecases/cities/get_city_names.dart';
import 'package:prodea/src/domain/usecases/donations/create_donation.dart';
import 'package:prodea/src/domain/usecases/donations/get_available_donations.dart';
import 'package:prodea/src/domain/usecases/donations/get_donation_photo_url.dart';
import 'package:prodea/src/domain/usecases/donations/get_my_donations.dart';
import 'package:prodea/src/domain/usecases/donations/get_requested_donations.dart';
import 'package:prodea/src/domain/usecases/donations/set_donation_as_canceled.dart';
import 'package:prodea/src/domain/usecases/donations/set_donation_as_delivered.dart';
import 'package:prodea/src/domain/usecases/donations/set_donation_as_requested.dart';
import 'package:prodea/src/domain/usecases/donations/set_donation_as_unrequested.dart';
import 'package:prodea/src/domain/usecases/navigation/get_current_route.dart';
import 'package:prodea/src/domain/usecases/navigation/go_back.dart';
import 'package:prodea/src/domain/usecases/navigation/go_to.dart';
import 'package:prodea/src/domain/usecases/network/get_connection_status.dart';
import 'package:prodea/src/domain/usecases/photo/pick_photo_from_camera.dart';
import 'package:prodea/src/domain/usecases/photo/pick_photo_from_gallery.dart';
import 'package:prodea/src/domain/usecases/user/get_beneficiaries.dart';
import 'package:prodea/src/domain/usecases/user/get_common_users.dart';
import 'package:prodea/src/domain/usecases/user/get_donors.dart';
import 'package:prodea/src/domain/usecases/user/get_user_by_id.dart';
import 'package:prodea/src/domain/usecases/user/set_user_as_authorized.dart';
import 'package:prodea/src/domain/usecases/user/set_user_as_denied.dart';
import 'package:prodea/src/presentation/controllers/auth_controller.dart';
import 'package:prodea/src/presentation/controllers/connection_state_controller.dart';
import 'package:prodea/src/presentation/controllers/navigation_controller.dart';
import 'package:prodea/src/presentation/dialogs/about_project_dialog.dart';
import 'package:prodea/src/presentation/dialogs/cancel_reason_dialog.dart';
import 'package:prodea/src/presentation/dialogs/city_select_dialog.dart';
import 'package:prodea/src/presentation/dialogs/donors_dialog.dart';
import 'package:prodea/src/presentation/dialogs/no_connection_dialog.dart';
import 'package:prodea/src/presentation/dialogs/user_info_dialog.dart';
import 'package:prodea/src/presentation/guards/auth_guard.dart';
import 'package:prodea/src/presentation/guards/guest_guard.dart';
import 'package:prodea/src/presentation/pages/account/profile_page.dart';
import 'package:prodea/src/presentation/pages/admin/admin_page.dart';
import 'package:prodea/src/presentation/pages/auth/forgot_password_page.dart';
import 'package:prodea/src/presentation/pages/auth/login_page.dart';
import 'package:prodea/src/presentation/pages/auth/register_page.dart';
import 'package:prodea/src/presentation/pages/main/available_donations_page.dart';
import 'package:prodea/src/presentation/pages/main/denied_page.dart';
import 'package:prodea/src/presentation/pages/main/donate_page.dart';
import 'package:prodea/src/presentation/pages/main/my_donations_page.dart';
import 'package:prodea/src/presentation/pages/main/requested_donations_page.dart';
import 'package:prodea/src/presentation/pages/main/waiting_page.dart';
import 'package:prodea/src/presentation/pages/main_page.dart';
import 'package:prodea/src/presentation/pages/web/home_page.dart';
import 'package:prodea/src/presentation/stores/cities_store.dart';
import 'package:prodea/src/presentation/stores/donations_store.dart';
import 'package:prodea/src/presentation/stores/donation_store.dart';
import 'package:prodea/src/presentation/stores/users_store.dart';
import 'package:prodea/src/presentation/stores/user_store.dart';
import 'package:prodea/src/presentation/widgets/app_bar/connection_app_bar.dart';
import 'package:prodea/src/presentation/widgets/app_bar/main_app_bar.dart';
import 'package:prodea/src/presentation/widgets/app_widget.dart';
import 'package:prodea/src/presentation/widgets/boot_widget.dart';
import 'package:prodea/src/presentation/widgets/button/connection_outlined_button.dart';
import 'package:prodea/src/presentation/widgets/button/loading_outlined_button.dart';
import 'package:prodea/src/presentation/widgets/layout/breakpoint.dart';
import 'package:prodea/src/presentation/widgets/layout/layout_breakpoint.dart';
import 'package:prodea/src/presentation/widgets/layout/layout_visibility.dart';
import 'package:prodea/src/themes/main_theme.dart';

void main() {}
