package com.mvc.dto;

public class MainDTO {
	//-------------은홍-----------
	//info
	private int cash;
	private String rankName;
	private int totalPoint;
	
	//cashHistory
	private int cash_amount;
	private String cash_time;
	private int cash_total;
	private String cash_details;
	
	//myPage
	private String postId;
	private int like;
	private String title;
	private int hits;
	private String item;
	private int recipePrice;
	private String nickName;
	private String commentid;
	private String comment_content;
	private String comment_date;
	
	//fileUpload
	private String th_imgid;
	private String th_imgOriName;
	private String th_imgNewName;
	private String th_imgField;
	private String th_fieldId;
	private String th_imgPath;
	
	private String imgid;
	private String imgOriName;
	private String imgNewName;
	private String imgField;
	private String fieldId;
	private String imgPath;
	
	private String field;
	
	public int getCash() {
		return cash;
	}
	public void setCash(int cash) {
		this.cash = cash;
	}
	public String getRankName() {
		return rankName;
	}
	public void setRankName(String rankName) {
		this.rankName = rankName;
	}
	public int getTotalPoint() {
		return totalPoint;
	}
	public void setTotalPoint(int totalPoint) {
		this.totalPoint = totalPoint;
	}
	
	public int getCash_amount() {
		return cash_amount;
	}
	public void setCash_amount(int cash_amount) {
		this.cash_amount = cash_amount;
	}
	public String getCash_time() {
		return cash_time;
	}
	public void setCash_time(String cash_time) {
		this.cash_time = cash_time;
	}
	public int getCash_total() {
		return cash_total;
	}
	public void setCash_total(int cash_total) {
		this.cash_total = cash_total;
	}
	public String getCash_details() {
		return cash_details;
	}
	public void setCash_details(String cash_details) {
		this.cash_details = cash_details;
	}
	
	
	public String getPostId() {
		return postId;
	}
	public void setPostId(String postId) {
		this.postId = postId;
	}
	public int getLike() {
		return like;
	}
	public void setLike(int like) {
		this.like = like;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public int getHits() {
		return hits;
	}
	public void setHits(int hits) {
		this.hits = hits;
	}
	public String getItem() {
		return item;
	}
	public void setItem(String item) {
		this.item = item;
	}
	public int getRecipePrice() {
		return recipePrice;
	}
	public void setRecipePrice(int recipePrice) {
		this.recipePrice = recipePrice;
	}
	public String getnickName() {
		return nickName;
	}
	public void setnickName(String nickName) {
		this.nickName = nickName;
	}
	

	public String getNickName() {
		return nickName;
	}
	public void setNickName(String nickName) {
		this.nickName = nickName;
	}
	public String getCommentid() {
		return commentid;
	}
	public void setCommentid(String commentid) {
		this.commentid = commentid;
	}
	public String getComment_content() {
		return comment_content;
	}
	public void setComment_content(String comment_content) {
		this.comment_content = comment_content;
	}
	public String getComment_date() {
		return comment_date;
	}
	public void setComment_date(String comment_date) {
		this.comment_date = comment_date;
	}

	
	public String getTh_imgid() {
		return th_imgid;
	}
	public void setTh_imgid(String th_imgid) {
		this.th_imgid = th_imgid;
	}
	public String getTh_imgOriName() {
		return th_imgOriName;
	}
	public void setTh_imgOriName(String th_imgOriName) {
		this.th_imgOriName = th_imgOriName;
	}
	public String getTh_imgNewName() {
		return th_imgNewName;
	}
	public void setTh_imgNewName(String th_imgNewName) {
		this.th_imgNewName = th_imgNewName;
	}
	public String getTh_imgField() {
		return th_imgField;
	}
	public void setTh_imgField(String th_imgField) {
		this.th_imgField = th_imgField;
	}
	public String getTh_fieldId() {
		return th_fieldId;
	}
	public void setTh_fieldId(String th_fieldId) {
		this.th_fieldId = th_fieldId;
	}
	public String getTh_imgPath() {
		return th_imgPath;
	}
	public void setTh_imgPath(String th_imgPath) {
		this.th_imgPath = th_imgPath;
	}
	public String getImgid() {
		return imgid;
	}
	public void setImgid(String imgid) {
		this.imgid = imgid;
	}
	public String getImgOriName() {
		return imgOriName;
	}
	public void setImgOriName(String imgOriName) {
		this.imgOriName = imgOriName;
	}
	public String getImgNewName() {
		return imgNewName;
	}
	public void setImgNewName(String imgNewName) {
		this.imgNewName = imgNewName;
	}
	public String getImgField() {
		return imgField;
	}
	public void setImgField(String imgField) {
		this.imgField = imgField;
	}
	public String getFieldId() {
		return fieldId;
	}
	public void setFieldId(String fieldId) {
		this.fieldId = fieldId;
	}
	public String getImgPath() {
		return imgPath;
	}
	public void setImgPath(String imgPath) {
		this.imgPath = imgPath;
	}
	public String getField() {
		return field;
	}
	public void setField(String field) {
		this.field = field;
	}




	//--------------의건--------------
	private String productid;
	private String productname;
	private int price;
	private int stock;
	private String productdetail;
	private String isdel;
	private String userid;
	private int productnumber;
	private int totalprice;
	public String getProductid() {
		return productid;
	}
	public void setProductid(String productid) {
		this.productid = productid;
	}
	public String getProductname() {
		return productname;
	}
	public void setProductname(String productname) {
		this.productname = productname;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public int getStock() {
		return stock;
	}
	public void setStock(int stock) {
		this.stock = stock;
	}
	public String getProductdetail() {
		return productdetail;
	}
	public void setProductdetail(String productdetail) {
		this.productdetail = productdetail;
	}
	public String getIsdel() {
		return isdel;
	}
	public void setIsdel(String isdel) {
		this.isdel = isdel;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public int getProductnumber() {
		return productnumber;
	}
	public void setProductnumber(int productnumber) {
		this.productnumber = productnumber;
	}
	public int getTotalprice() {
		return totalprice;
	}
	public void setTotalprice(int totalprice) {
		this.totalprice = totalprice;
	}
	
	
}
