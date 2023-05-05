import 'package:dio/dio.dart';
import 'package:readme_app/core/constants/http.dart';
import 'package:readme_app/dto/cart_dto/cart_dto.dart';
import 'package:readme_app/dto/main_dto/main_dto.dart';
import 'package:readme_app/dto/response_dto/response_dto.dart';
import 'package:readme_app/view/page/main/main_page/main_page_view_model.dart';

class BookRepository {
  static final BookRepository _instance = BookRepository._single();

  factory BookRepository() {
    return _instance;
  }

  BookRepository._single();

  Future<ResponseDTO> findCartList() async {
    try {
      // TODO user_id 부분 추후에 변경
      Response response =
          await MyHttp.get().get("/carts/1/users");
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

      List<CartDTO> cartList = [];
      for (var cartBook in responseDTO.data) {
        CartDTO cartDTO = CartDTO.fromJson(cartBook);
        cartList.add(cartDTO);
      }

      responseDTO.data = cartList;

      return responseDTO;
    } catch (e) {
      return ResponseDTO(code: -1, msg: "실패 : ${e}");
    }
  }

  Future<ResponseDTO> getBanner() async {
    try {
      Response response =
          await MyHttp.get().get("/books?page=0&size=3");
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

      MainDTO mainDTO = MainDTO.fromJson(responseDTO.data);
      responseDTO.data = mainDTO;
      return responseDTO;
    } catch (e) {
      // print(e);
      return ResponseDTO(code: -1, msg: "실패 : ${e}");
    }
  }

  Future<ResponseDTO> mainList(BookSearchType type) async {
    String endPoint =
        type == BookSearchType.best ? "/best-sellers" : "/${type.name}";
    if (type.name == "total" || type.name == "latest") {
      endPoint = "";
    }
    try {
      Response response = await MyHttp.get()
          .get("/books$endPoint?page=0&size=10");

      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      MainDTO mainDTO = MainDTO.fromJson(responseDTO.data);
      responseDTO.data = mainDTO;

      return responseDTO;
    } catch (e) {
      return ResponseDTO(code: -1, msg: "실패 : ${e}");
    }
  }

  Future<ResponseDTO> searchMainListPage(int page, BookSearchType type) async {
    String endPoint =
        type == BookSearchType.best ? "/best-sellers" : "/${type.name}";
    if (type.name == "total" || type.name == "latest") {
      endPoint = "";
    }
    try {
      Response response = await MyHttp.get()
          .get("/books$endPoint?page=$page&size=10");
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      MainDTO mainDTO = MainDTO.fromJson(responseDTO.data);
      responseDTO.data = mainDTO;
      return responseDTO;
    } catch (e) {
      return ResponseDTO(code: -1, msg: "실패 : ${e}");
    }
  }

  Future<ResponseDTO> deleteCartBook(int id) async {
    try {
      Response response = await MyHttp.get().delete("/carts/$id");
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      return responseDTO;
    } catch (e) {
      return ResponseDTO(code: -1, msg: "실패 : ${e}");
    }
  }

  Future<ResponseDTO> addCart(int bookId, int userId) async {
    try{
      Response response = await MyHttp.get().post("/carts", data: {"userId" : userId, "bookId" : bookId});
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      CartDTO cartDTO = CartDTO.fromJson(responseDTO.data);
      responseDTO.data = cartDTO;
      return responseDTO;
    } catch(e) {
      return ResponseDTO(code: -1, msg: "실패 : ${e}");
    }
  }
}
