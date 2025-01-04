export class BlogClass {
  constructor(id: string, title: string, summary: string, img: ResourceStr, author: string, createdAt: string,
    viewCount: number,
    likeCount: number, commentCount: number) {
    this.id = id
    this.title = title
    this.summary = summary
    this.img = img
    this.author = author
    this.createdAt = createdAt
    this.viewCount = viewCount
    this.likeCount = likeCount
    this.commentCount = commentCount
  }

  id: string = '';
  title: string = '';
  summary: string = '';
  img: ResourceStr = '';
  author: string = '';
  createdAt: string = '';
  viewCount: number = 0;
  likeCount: number = 0;
  commentCount: number = 0;
}