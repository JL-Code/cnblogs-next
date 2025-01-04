export class BlogClass {
  constructor(Author: string, Avatar: string, BlogApp: null, CommentCount: number, Description: string,
    DiggCount: number, Id: number, PostDate: string, Title: string, Url: string, ViewCount: number) {
    this.Author = Author;
    this.Avatar = Avatar;
    this.BlogApp = BlogApp;
    this.CommentCount = CommentCount;
    this.Description = Description;
    this.DiggCount = DiggCount;
    this.Id = Id;
    this.PostDate = PostDate;
    this.Title = Title;
    this.Url = Url;
    this.ViewCount = ViewCount;
  }

  Author: string;
  Avatar: string;
  BlogApp: null;
  CommentCount: number;
  Description: string;
  DiggCount: number;
  Id: number;
  PostDate: string;
  Title: string;
  Url: string;
  ViewCount: number;
}